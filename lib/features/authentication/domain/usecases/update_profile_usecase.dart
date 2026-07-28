import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/authentication/domain/entities/app_user.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, AppUser>> call({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  }) =>
      _repository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        address: address,
      );
}
