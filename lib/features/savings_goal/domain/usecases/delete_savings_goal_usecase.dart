import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';

class DeleteSavingsGoalUseCase {
  const DeleteSavingsGoalUseCase(this._repository);
  final ISavingsGoalRepository _repository;

  Future<Either<Failure, Unit>> call(SavingsGoal goal) =>
      _repository.deleteSavingsGoal(goal);
}
