import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:spendly_app/core/config/env_config.dart';
import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/core/network/token_storage.dart';
import 'package:spendly_app/features/authentication/data/models/app_user_model.dart';

/// Thrown when the user backs out of the native Google/Facebook picker —
/// distinct from a real failure so the repository can surface a silent
/// no-op instead of an error snackbar.
class OAuthCancelledException implements Exception {}

/// Custom backend's `/api/v1/auth` + `/api/v1/users` — JWT access+refresh
/// auth (see `BackendApiClient` for the refresh/retry interceptor).
class BackendAuthRemoteDataSource {
  BackendAuthRemoteDataSource(this._client, this._tokenStorage);

  final BackendApiClient _client;
  final TokenStorage _tokenStorage;

  Future<AppUserModel?> getCurrentUser() async {
    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken == null) return null;
    try {
      return await _fetchMe();
    } on DioException catch (e) {
      // A connectivity-type failure (no server reachable at all — the
      // refresh interceptor never even got a response) doesn't mean the
      // session is invalid; rethrow so the repository can surface it as a
      // `NetworkFailure` instead of silently signing the user out.
      const connectivityTypes = {
        DioExceptionType.connectionError,
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      };
      if (connectivityTypes.contains(e.type)) rethrow;
      // Any other Dio failure (401 after a failed refresh, etc.) means the
      // session itself is unrecoverable — same "signed out" contract as
      // Supabase's `_client.auth.currentUser == null`.
      await _tokenStorage.clear();
      return null;
    } catch (_) {
      await _tokenStorage.clear();
      return null;
    }
  }

  Future<AppUserModel> signInWithEmail(String email, String password) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      'auth/login',
      data: {'email': email, 'password': password},
    );
    await _saveTokensFrom(response.data);
    return _fetchMe();
  }

  Future<AppUserModel> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      // clientId is REQUIRED on iOS (see EnvConfig.googleIosClientId doc) —
      // without it, GIDSignIn crashes natively instead of failing gracefully.
      clientId: EnvConfig.googleIosClientId,
      serverClientId: EnvConfig.googleServerClientId,
    );
    final account = await googleSignIn.signIn();
    if (account == null) throw OAuthCancelledException();
    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw Exception('Không lấy được ID token từ Google');
    }
    return _signInWithOAuth('GOOGLE', idToken);
  }

  Future<AppUserModel> signInWithFacebook() async {
    final result = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);
    switch (result.status) {
      case LoginStatus.success:
        final accessToken = result.accessToken;
        if (accessToken == null) {
          throw Exception('Không lấy được access token từ Facebook');
        }
        return _signInWithOAuth('FACEBOOK', accessToken.tokenString);
      case LoginStatus.cancelled:
        throw OAuthCancelledException();
      case LoginStatus.failed:
      case LoginStatus.operationInProgress:
        throw Exception(result.message ?? 'Đăng nhập Facebook thất bại');
    }
  }

  Future<AppUserModel> _signInWithOAuth(String provider, String token) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      'auth/oauth',
      data: {'provider': provider, 'token': token},
    );
    await _saveTokensFrom(response.data);
    return _fetchMe();
  }

  /// Registration no longer returns a session directly — the backend sends
  /// a 6-digit OTP email and the response is just `{userId, email,
  /// otpRequired:true}`. Returns the email to verify; [verifyOtp] is what
  /// actually yields tokens.
  Future<String> registerWithEmail(String email, String password) async {
    // The backend requires firstName/lastName; the Register screen only
    // collects email/password, so derive a placeholder the same way the
    // Supabase path already does for legacy rows — the user renames later
    // via Edit Profile.
    final localPart = email.split('@').first;
    await _client.dio.post<Map<String, dynamic>>(
      'auth/register',
      data: {
        'email': email,
        'password': password,
        'firstName': '',
        'lastName': localPart,
      },
    );
    return email;
  }

  Future<AppUserModel> verifyOtp(String email, String code) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      'auth/verify-otp',
      data: {'email': email, 'code': code},
    );
    await _saveTokensFrom(response.data);
    return _fetchMe();
  }

  Future<void> resendOtp(String email) async {
    await _client.dio.post('auth/resend-otp', data: {'email': email});
  }

  Future<void> signOut() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    try {
      if (refreshToken != null) {
        await _client.dio
            .post('auth/logout', data: {'refreshToken': refreshToken});
      }
    } finally {
      await _tokenStorage.clear();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _client.dio.post('auth/forgot-password', data: {'email': email});
  }

  Future<AppUserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  }) async {
    // The backend has no email-change endpoint — `email` is accepted for
    // interface parity with the Supabase path but not sent.
    final response = await _client.dio.patch<Map<String, dynamic>>(
      'users/me',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'address': address,
      },
    );
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>;
    return AppUserModel.fromBackendJson(data);
  }

  Future<AppUserModel> _fetchMe() async {
    final response = await _client.dio.get<Map<String, dynamic>>('users/me');
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>;
    return AppUserModel.fromBackendJson(data);
  }

  Future<void> _saveTokensFrom(Map<String, dynamic>? body) async {
    final data =
        unwrapBackendData(body, statusCode: null) as Map<String, dynamic>;
    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}
