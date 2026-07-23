import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_user.dart';
import '../repositories/i_auth_repository.dart';

class SignInWithEmailUseCase {
  const SignInWithEmailUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || !email.contains('@')) {
      return Future.value(const Left(ValidationFailure('Email không hợp lệ')));
    }
    if (password.length < 6) {
      return Future.value(
        const Left(ValidationFailure('Mật khẩu phải có ít nhất 6 ký tự')),
      );
    }
    return _repository.signInWithEmail(email: email, password: password);
  }
}
