import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';

class RefreshSavingsGoalUseCase {
  const RefreshSavingsGoalUseCase(this._repository);
  final ISavingsGoalRepository _repository;

  Future<Either<Failure, SavingsGoal>> call(SavingsGoal goal) =>
      _repository.refreshSavingsGoal(goal);
}
