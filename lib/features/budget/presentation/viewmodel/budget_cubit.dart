import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/budget/domain/usecases/get_budgets_usecase.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit(this._getBudgetsUseCase) : super(const BudgetLoading());

  final GetBudgetsUseCase _getBudgetsUseCase;

  Future<void> load(DateTime month) async {
    emit(const BudgetLoading());
    final result = await _getBudgetsUseCase(month);
    result.fold(
      (failure) => emit(BudgetError(failure.message)),
      (items) => emit(BudgetLoaded(items, month)),
    );
  }
}
