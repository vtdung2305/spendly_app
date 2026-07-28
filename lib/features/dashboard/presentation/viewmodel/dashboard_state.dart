import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
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
      {this.overBudgetItem, this.yearToDateSavings = 0});
  final DashboardSummary summary;

  /// First over-budget category (if any), for the warning banner — per
  /// design handoff ("{category} đã vượt ngân sách {percent}%").
  final BudgetItem? overBudgetItem;

  /// Net savings from Jan 1 of the current year to today — for the "Mục
  /// tiêu tiết kiệm" progress card.
  final double yearToDateSavings;

  @override
  List<Object?> get props => [summary, overBudgetItem, yearToDateSavings];
}

class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
