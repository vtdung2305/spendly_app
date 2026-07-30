import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';

class UpdateSavingsGoalUseCase {
  const UpdateSavingsGoalUseCase(this._repository);
  final ISavingsGoalRepository _repository;

  Future<Either<Failure, SavingsGoal>> call(int year, double targetAmount) =>
      _repository.updateSavingsGoal(year, targetAmount);
}
