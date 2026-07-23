import '../models/app_user_model.dart';

/// In-memory stand-in for a Supabase Auth datasource. Swap for a real
/// `AuthRemoteDataSource` (Supabase) behind the same method signatures once
/// the backend is wired up — [IAuthRepository] callers won't need to change.
class AuthMockDataSource {
  AppUserModel? _session;

  Future<AppUserModel?> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _session;
  }

  Future<AppUserModel> signInWithEmail(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (password == 'wrong') {
      throw const AuthMockException('Email hoặc mật khẩu không đúng');
    }
    _session = const AppUserModel(id: 'u-1', name: 'Minh Anh', email: 'minhanh@gmail.com');
    return _session!;
  }

  Future<AppUserModel> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _session = const AppUserModel(id: 'u-1', name: 'Minh Anh', email: 'minhanh@gmail.com');
    return _session!;
  }

  Future<AppUserModel> registerWithEmail(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _session = AppUserModel(id: 'u-1', name: 'Minh Anh', email: email);
    return _session!;
  }

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _session = null;
  }
}

class AuthMockException implements Exception {
  const AuthMockException(this.message);
  final String message;
}
