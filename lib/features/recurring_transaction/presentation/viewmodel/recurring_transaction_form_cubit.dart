import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/usecases/get_categories_usecase.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/recurring_transaction/domain/usecases/add_recurring_transaction_usecase.dart';
import 'package:spendly_app/features/recurring_transaction/domain/usecases/delete_recurring_transaction_usecase.dart';
import 'package:spendly_app/features/recurring_transaction/domain/usecases/update_recurring_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'recurring_transaction_form_state.dart';

class RecurringTransactionFormCubit extends Cubit<RecurringTransactionFormState> {
  RecurringTransactionFormCubit(
    this._getCategoriesUseCase,
    this._addRecurringTransactionUseCase,
    this._updateRecurringTransactionUseCase,
    this._deleteRecurringTransactionUseCase, {
    RecurringTransaction? existing,
  })  : _existing = existing,
        super(
          existing != null
              ? RecurringTransactionFormState(
                  type: existing.type,
                  category: existing.category,
                  label: existing.label,
                  amount: existing.amount,
                  dayOfMonth: existing.dayOfMonth,
                  isActive: existing.isActive,
                )
              : const RecurringTransactionFormState(),
        );

  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddRecurringTransactionUseCase _addRecurringTransactionUseCase;
  final UpdateRecurringTransactionUseCase _updateRecurringTransactionUseCase;
  final DeleteRecurringTransactionUseCase _deleteRecurringTransactionUseCase;
  final RecurringTransaction? _existing;

  bool get isEditing => _existing != null;

  Future<void> loadCategories() async {
    final expenseResult =
        await _getCategoriesUseCase(type: CategoryType.expense);
    final incomeResult = await _getCategoriesUseCase(type: CategoryType.income);
    final expenseCategories = expenseResult.fold((_) => <Category>[], (c) => c);
    final incomeCategories = incomeResult.fold((_) => <Category>[], (c) => c);
    emit(state.copyWith(
      expenseCategories: expenseCategories,
      incomeCategories: incomeCategories,
    ));
  }

  void selectType(TransactionType type) {
    emit(state.copyWith(type: type, clearCategory: true));
  }

  void selectCategory(Category category) {
    emit(state.copyWith(category: category));
  }

  void setLabel(String label) {
    emit(state.copyWith(label: label));
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  void selectDay(int day) {
    emit(state.copyWith(dayOfMonth: day));
  }

  void toggleActive() {
    emit(state.copyWith(isActive: !state.isActive));
  }

  Future<void> save() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = isEditing
        ? await _updateRecurringTransactionUseCase(RecurringTransaction(
            id: _existing!.id,
            type: state.type,
            category: state.category!,
            label: state.label.trim(),
            amount: state.amount,
            dayOfMonth: state.dayOfMonth,
            isActive: state.isActive,
          ))
        : await _addRecurringTransactionUseCase(
            type: state.type,
            category: state.category!,
            label: state.label.trim(),
            amount: state.amount,
            dayOfMonth: state.dayOfMonth,
            isActive: state.isActive,
          );

    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, saved: true)),
    );
  }

  Future<void> delete() async {
    final existing = _existing;
    if (existing == null) return;
    final result = await _deleteRecurringTransactionUseCase(existing.id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(deleted: true)),
    );
  }
}
