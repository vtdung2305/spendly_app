import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_user.dart';
import '../repositories/i_auth_repository.dart';

class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, AppUser>> call() => _repository.signInWithGoogle();
}
