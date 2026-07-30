import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/register_with_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/resend_otp_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_facebook_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/update_profile_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'auth_form_result.dart';
import 'auth_state.dart';

/// Owns the app-wide session: who's logged in, used by Splash to route and
/// by Profile to sign out. Login/Register forms report results back here so
/// the rest of the app (router redirect, Profile) reacts to one source of
/// truth instead of each page tracking its own "am I logged in" copy.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignInWithFacebookUseCase signInWithFacebookUseCase,
    required RegisterWithEmailUseCase registerWithEmailUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResendOtpUseCase resendOtpUseCase,
    required SignOutUseCase signOutUseCase,
    required SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _signInWithEmailUseCase = signInWithEmailUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signInWithFacebookUseCase = signInWithFacebookUseCase,
        _registerWithEmailUseCase = registerWithEmailUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _resendOtpUseCase = resendOtpUseCase,
        _signOutUseCase = signOutUseCase,
        _sendPasswordResetEmailUseCase = sendPasswordResetEmailUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        super(const AuthInitial());

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;
  final RegisterWithEmailUseCase _registerWithEmailUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final SignOutUseCase _signOutUseCase;
  final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  /// The OS-level `connectivity_plus` interface check is unreliable right at
  /// app startup/reload — it can report `none` for a brief moment before the
  /// platform channel settles, even with a perfectly good connection. So
  /// instead of trusting that check upfront, always attempt the real session
  /// call and only treat it as offline if it fails with an actual
  /// [NetworkFailure].
  Future<void> checkSession() async {
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) => emit(failure is NetworkFailure
          ? const AuthOffline()
          : AuthCheckFailed(failure.message)),
      (user) => emit(
          user == null ? const AuthUnauthenticated() : AuthAuthenticated(user)),
    );
  }

  /// [AuthFormResult.otpEmail] set means the account isn't OTP-verified yet
  /// (backend's `403 EMAIL_NOT_VERIFIED`) — the page should route to Verify
  /// OTP instead of showing this as a plain field/snackbar error.
  Future<AuthFormResult> signInWithEmail(String email, String password) async {
    final result =
        await _signInWithEmailUseCase(email: email, password: password);
    return result.fold(
      (failure) => failure.code == 'EMAIL_NOT_VERIFIED'
          ? AuthFormResult(otpEmail: email)
          : AuthFormResult(errorMessage: failure.message),
      (user) {
        emit(AuthAuthenticated(user));
        return const AuthFormResult();
      },
    );
  }

  /// A `null` return means either success or the user simply cancelled the
  /// native picker (`OAUTH_CANCELLED`) — the page should treat both the
  /// same way (no error snackbar), distinguished only by whether
  /// [AuthAuthenticated] was emitted.
  Future<String?> signInWithGoogle() async {
    final result = await _signInWithGoogleUseCase();
    return result.fold(
      (failure) => failure.code == 'OAUTH_CANCELLED' ? null : failure.message,
      (user) {
        emit(AuthAuthenticated(user));
        return null;
      },
    );
  }

  Future<String?> signInWithFacebook() async {
    final result = await _signInWithFacebookUseCase();
    return result.fold(
      (failure) => failure.code == 'OAUTH_CANCELLED' ? null : failure.message,
      (user) {
        emit(AuthAuthenticated(user));
        return null;
      },
    );
  }

  /// [AuthFormResult.otpEmail] set means registration succeeded but a
  /// session doesn't exist yet — the backend always requires OTP
  /// verification now (Supabase mode instead authenticates immediately, or
  /// fails with its own "check your email" message).
  Future<AuthFormResult> registerWithEmail(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final result = await _registerWithEmailUseCase(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    return result.fold(
      (failure) => AuthFormResult(errorMessage: failure.message),
      (outcome) {
        if (outcome.user != null) {
          emit(AuthAuthenticated(outcome.user!));
          return const AuthFormResult();
        }
        return AuthFormResult(otpEmail: outcome.otpEmail);
      },
    );
  }

  Future<AuthFormResult> verifyOtp(String email, String code) async {
    final result = await _verifyOtpUseCase(email: email, code: code);
    return result.fold(
      (failure) => AuthFormResult(
          errorMessage: failure.message, errorCode: failure.code),
      (user) {
        emit(AuthAuthenticated(user));
        return const AuthFormResult();
      },
    );
  }

  Future<String?> resendOtp(String email) async {
    final result = await _resendOtpUseCase(email);
    return result.fold((failure) => failure.message, (_) => null);
  }

  Future<void> signOut() async {
    await _signOutUseCase();
    emit(const AuthUnauthenticated());
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    final result = await _sendPasswordResetEmailUseCase(email);
    return result.fold((failure) => failure.message, (_) => null);
  }

  Future<String?> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  }) async {
    final result = await _updateProfileUseCase(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      address: address,
    );
    return result.fold(
      (failure) => failure.message,
      (user) {
        emit(AuthAuthenticated(user));
        return null;
      },
    );
  }
}
