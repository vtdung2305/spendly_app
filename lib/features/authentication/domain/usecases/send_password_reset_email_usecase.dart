import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';

class SendPasswordResetEmailUseCase {
  const SendPasswordResetEmailUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, Unit>> call(String email) {
    if (email.trim().isEmpty || !email.contains('@')) {
      return Future.value(const Left(ValidationFailure('Email không hợp lệ')));
    }
    return _repository.sendPasswordResetEmail(email);
  }
}
