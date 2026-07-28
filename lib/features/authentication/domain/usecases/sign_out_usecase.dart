import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.signOut();
}
