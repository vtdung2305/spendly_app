import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';

abstract class ISavingsGoalRepository {
  Future<Either<Failure, SavingsGoal>> getSavingsGoal(int year);

  /// Create-or-update semantics in Supabase mode (single year-agnostic
  /// target) — see `SavingsGoalRepository.addSavingsGoal`. Backend mode
  /// rejects a duplicate [year] with `409 SAVINGS_GOAL_ALREADY_EXISTS`.
  Future<Either<Failure, SavingsGoal>> addSavingsGoal(
      int year, double targetAmount);

  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(
      int year, double targetAmount);

  /// Per-month net contributions (income − expense) for [year], most
  /// recent month first.
  Future<Either<Failure, List<SavingsContribution>>> getContributionHistory(
      int year);
}
