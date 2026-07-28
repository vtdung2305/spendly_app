import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/domain/usecases/get_budgets_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_year_to_date_savings_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
    this._getDashboardSummaryUseCase,
    this._getBudgetsUseCase,
    this._getYearToDateSavingsUseCase,
  ) : super(const DashboardLoading());

  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;
  final GetBudgetsUseCase _getBudgetsUseCase;
  final GetYearToDateSavingsUseCase _getYearToDateSavingsUseCase;

  Future<void> load(DateTime month) async {
    emit(const DashboardLoading());
    final result = await _getDashboardSummaryUseCase(month);
    final budgetsResult = await _getBudgetsUseCase();
    final savingsResult = await _getYearToDateSavingsUseCase(month.year);
    final BudgetItem? overBudgetItem = budgetsResult.fold(
      (_) => null,
      (items) {
        for (final item in items) {
          if (item.isOverBudget) return item;
        }
        return null;
      },
    );
    final yearToDateSavings =
        savingsResult.fold((_) => 0.0, (savings) => savings);
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (summary) => emit(DashboardLoaded(
        summary,
        overBudgetItem: overBudgetItem,
        yearToDateSavings: yearToDateSavings,
      )),
    );
  }
}
