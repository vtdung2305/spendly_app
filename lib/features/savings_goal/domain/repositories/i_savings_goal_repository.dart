import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';

abstract class ISavingsGoalRepository {
  Future<Either<Failure, SavingsGoal>> getSavingsGoal(int year);

  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(
      int year, double targetAmount);
}
