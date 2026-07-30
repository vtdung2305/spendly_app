import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/authentication/domain/entities/app_user.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String code,
  }) {
    if (code.length != 6) {
      return Future.value(
          const Left(ValidationFailure('Mã xác thực phải gồm 6 số')));
    }
    return _repository.verifyOtp(email: email, code: code);
  }
}
