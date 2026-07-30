import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.summary,
      {this.overBudgetItem, required this.savingsGoal});
  final DashboardSummary summary;

  /// First over-budget category (if any), for the warning banner — per
  /// design handoff ("{category} đã vượt ngân sách {percent}%").
  final BudgetItem? overBudgetItem;

  /// Backs the "Mục tiêu tiết kiệm" progress card.
  final SavingsGoal savingsGoal;

  @override
  List<Object?> get props => [summary, overBudgetItem, savingsGoal];
}

class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
