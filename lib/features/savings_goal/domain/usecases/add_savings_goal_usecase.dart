import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';

class AddSavingsGoalUseCase {
  const AddSavingsGoalUseCase(this._repository);
  final ISavingsGoalRepository _repository;

  Future<Either<Failure, SavingsGoal>> call({
    required String name,
    required double targetAmount,
    required DateTime deadline,
    double initialAmount = 0,
  }) =>
      _repository.addSavingsGoal(
        name: name,
        targetAmount: targetAmount,
        deadline: deadline,
        initialAmount: initialAmount,
      );
}
