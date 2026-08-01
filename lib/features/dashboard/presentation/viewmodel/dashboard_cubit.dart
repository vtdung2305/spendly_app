import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/domain/usecases/get_budgets_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/get_savings_goal_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/update_savings_goal_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_dashboard_summary_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
    this._getDashboardSummaryUseCase,
    this._getBudgetsUseCase,
    this._getSavingsGoalUseCase,
    this._updateSavingsGoalUseCase,
  ) : super(const DashboardLoading());

  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;
  final GetBudgetsUseCase _getBudgetsUseCase;
  final GetSavingsGoalUseCase _getSavingsGoalUseCase;
  final UpdateSavingsGoalUseCase _updateSavingsGoalUseCase;

  Future<void> load(DateTime month) async {
    emit(const DashboardLoading());
    final result = await _getDashboardSummaryUseCase(month);
    final budgetsResult = await _getBudgetsUseCase(month);
    final savingsGoalResult = await _getSavingsGoalUseCase(month.year);
    final BudgetItem? overBudgetItem = budgetsResult.fold(
      (_) => null,
      (items) {
        for (final item in items) {
          if (item.isOverBudget) return item;
        }
        return null;
      },
    );
    final savingsGoal = savingsGoalResult.fold(
      (_) => SavingsGoal(
          year: month.year, targetAmount: 0, currentAmount: 0, percent: 0),
      (goal) => goal,
    );
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (summary) => emit(DashboardLoaded(
        summary,
        overBudgetItem: overBudgetItem,
        savingsGoal: savingsGoal,
      )),
    );
  }

  /// Returns an error message on failure, or null on success.
  Future<String?> updateSavingsGoal(int year, double amount) async {
    final result = await _updateSavingsGoalUseCase(year, amount);
    return result.fold(
      (failure) => failure.message,
      (goal) {
        final current = state;
        if (current is DashboardLoaded) {
          emit(DashboardLoaded(
            current.summary,
            overBudgetItem: current.overBudgetItem,
            savingsGoal: goal,
          ));
        }
        return null;
      },
    );
  }
}
