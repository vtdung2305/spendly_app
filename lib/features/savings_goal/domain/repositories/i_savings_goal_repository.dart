import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';

abstract class ISavingsGoalRepository {
  /// The Dashboard's "current" goal. Supabase: the single year-agnostic
  /// goal, using [year] for its transaction-based `currentAmount` calc.
  /// Backend: the goal with the nearest upcoming deadline (or nearest past
  /// one if all have expired; a zeroed placeholder if the user has none)
  /// — [year] is unused there.
  Future<Either<Failure, SavingsGoal>> getSavingsGoal(int year);

  /// Re-fetches [goal] by identity — backend: `goal.id`; Supabase:
  /// `goal.deadline.year` — to refresh the Savings Goal Detail screen.
  Future<Either<Failure, SavingsGoal>> refreshSavingsGoal(SavingsGoal goal);

  Future<Either<Failure, SavingsGoal>> addSavingsGoal({
    required String name,
    required double targetAmount,
    required DateTime deadline,
    double initialAmount = 0,
  });

  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(SavingsGoal goal);

  Future<Either<Failure, Unit>> deleteSavingsGoal(SavingsGoal goal);

  /// Per-month net contributions towards [goal], most recent month first.
  Future<Either<Failure, List<SavingsContribution>>> getContributionHistory(
      SavingsGoal goal);
}
