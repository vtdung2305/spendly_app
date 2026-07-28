import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/authentication/domain/entities/app_user.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';

class UpdateSavingsGoalUseCase {
  const UpdateSavingsGoalUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, AppUser>> call(double amount) =>
      _repository.updateSavingsGoal(amount);
}
