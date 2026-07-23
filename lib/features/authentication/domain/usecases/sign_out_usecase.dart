import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/i_auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.signOut();
}
