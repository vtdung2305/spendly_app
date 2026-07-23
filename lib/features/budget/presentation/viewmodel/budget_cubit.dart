import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_budgets_usecase.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit(this._getBudgetsUseCase) : super(const BudgetLoading());

  final GetBudgetsUseCase _getBudgetsUseCase;

  Future<void> load() async {
    emit(const BudgetLoading());
    final result = await _getBudgetsUseCase();
    result.fold(
      (failure) => emit(BudgetError(failure.message)),
      (items) => emit(BudgetLoaded(items)),
    );
  }
}
