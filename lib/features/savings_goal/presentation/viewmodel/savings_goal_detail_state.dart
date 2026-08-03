import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';

sealed class SavingsGoalDetailState {
  const SavingsGoalDetailState();
}

class SavingsGoalDetailLoading extends SavingsGoalDetailState {
  const SavingsGoalDetailLoading();
}

class SavingsGoalDetailLoaded extends SavingsGoalDetailState {
  const SavingsGoalDetailLoaded(this.goal, this.history);

  final SavingsGoal goal;
  final List<SavingsContribution> history;

  double get averagePerMonth => history.isEmpty
      ? 0
      : history.fold<double>(0, (sum, c) => sum + c.amount) / history.length;
}

class SavingsGoalDetailError extends SavingsGoalDetailState {
  const SavingsGoalDetailError(this.message);
  final String message;
}
