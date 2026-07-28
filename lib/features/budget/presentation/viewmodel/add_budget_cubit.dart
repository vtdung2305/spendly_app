import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:spendly_app/features/transactions/domain/entities/expense_category.dart';
import 'add_budget_state.dart';

class AddBudgetCubit extends Cubit<AddBudgetState> {
  AddBudgetCubit(this._addBudgetUseCase) : super(const AddBudgetState());

  final AddBudgetUseCase _addBudgetUseCase;

  void selectCategory(ExpenseCategory category) {
    emit(state.copyWith(category: category));
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  Future<void> save() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = await _addBudgetUseCase(state.category!, state.amount);
    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, saved: true)),
    );
  }
}
