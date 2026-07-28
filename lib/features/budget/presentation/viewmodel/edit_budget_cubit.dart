import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:spendly_app/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'edit_budget_state.dart';

class EditBudgetCubit extends Cubit<EditBudgetState> {
  EditBudgetCubit(this._addBudgetUseCase, this._deleteBudgetUseCase, this.item)
      : super(EditBudgetState(amount: item.budgetAmount));

  final AddBudgetUseCase _addBudgetUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;

  /// Category/used-amount are read-only in this screen — kept for display.
  final BudgetItem item;

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount, clearErrorMessage: true));
  }

  Future<void> save() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = await _addBudgetUseCase(item.category, state.amount);
    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, saved: true)),
    );
  }

  Future<void> delete() async {
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = await _deleteBudgetUseCase(item.category);
    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, deleted: true)),
    );
  }
}
