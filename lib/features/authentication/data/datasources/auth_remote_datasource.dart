import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spendly_app/features/authentication/data/models/app_user_model.dart';

/// Supabase Auth + `profiles` table. Google Sign-In isn't wired yet
/// (email/password only) — [signInWithGoogle] throws until it is.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<AppUserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return _fetchProfile(user.id);
  }

  Future<AppUserModel> signInWithEmail(String email, String password) async {
    final response =
        await _client.auth.signInWithPassword(email: email, password: password);
    final user = response.user;
    if (user == null) {
      throw const AuthException('Đăng nhập thất bại, vui lòng thử lại');
    }
    return _fetchProfile(user.id);
  }

  Future<AppUserModel> signInWithGoogle() {
    throw const AuthException(
        'Đăng nhập Google chưa được hỗ trợ trong phiên bản này');
  }

  Future<AppUserModel> registerWithEmail(String email, String password) async {
    final response =
        await _client.auth.signUp(email: email, password: password);
    final user = response.user;
    if (user == null) {
      throw const AuthException('Đăng ký thất bại, vui lòng thử lại');
    }
    if (response.session == null) {
      // "Confirm email" is enabled in Supabase Auth settings — the user row
      // (and its profiles trigger) exist, but there's no JWT yet, so RLS
      // blocks reading it back until the confirmation link is clicked.
      throw const AuthException(
        'Vui lòng kiểm tra email để xác nhận tài khoản, sau đó đăng nhập lại. '
        '(Hoặc tắt "Confirm email" trong Supabase Auth settings để bỏ qua bước này.)',
      );
    }
    // The `on_auth_user_created` trigger inserts the profiles row as part of
    // the same transaction as the auth.users insert, so it's already there.
    return _fetchProfile(user.id);
  }

  Future<void> signOut() => _client.auth.signOut();

  Future<void> sendPasswordResetEmail(String email) =>
      _client.auth.resetPasswordForEmail(email);

  Future<AppUserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('profiles').update({
      'first_name': firstName,
      'last_name': lastName,
      'full_name': [firstName, lastName]
          .where((part) => part.trim().isNotEmpty)
          .join(' '),
      'phone': phone,
      'email': email,
      'address': address,
    }).eq('id', userId);
    return _fetchProfile(userId);
  }

  Future<AppUserModel> updateSavingsGoal(double amount) async {
    final userId = _client.auth.currentUser!.id;
    await _client
        .from('profiles')
        .update({'savings_goal_amount': amount}).eq('id', userId);
    return _fetchProfile(userId);
  }

  Future<AppUserModel> _fetchProfile(String userId) async {
    final row =
        await _client.from('profiles').select().eq('id', userId).single();
    return AppUserModel.fromJson(row);
  }
}
