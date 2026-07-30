import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/usecases/get_categories_usecase.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit(
    this._getCategoriesUseCase,
    this._addTransactionUseCase,
    this._updateTransactionUseCase, {
    TransactionType initialTab = TransactionType.expense,
    Transaction? existingTransaction,
  })  : _existingTransaction = existingTransaction,
        super(
          existingTransaction != null
              ? AddTransactionState(
                  type: existingTransaction.type,
                  category: existingTransaction.category,
                  amount: existingTransaction.amount,
                  date: existingTransaction.date,
                  note: existingTransaction.note ?? '',
                )
              : AddTransactionState(type: initialTab, date: DateTime.now()),
        );

  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddTransactionUseCase _addTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final Transaction? _existingTransaction;

  bool get isEditing => _existingTransaction != null;
  double get initialAmount => _existingTransaction?.amount ?? 0;
  String get initialNote => _existingTransaction?.note ?? '';

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

  void selectTab(TransactionType type) {
    emit(state.copyWith(type: type, clearCategory: true));
  }

  void selectCategory(Category category) {
    emit(state.copyWith(category: category));
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  void setDate(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void setNote(String note) {
    emit(state.copyWith(note: note));
  }

  Future<void> save() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final transaction = Transaction(
      id: _existingTransaction?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      type: state.type,
      amount: state.amount,
      date: state.date ?? DateTime.now(),
      category: state.category,
      note: state.note.isEmpty ? null : state.note,
    );

    if (isEditing) {
      final result = await _updateTransactionUseCase(transaction);
      result.fold(
        (failure) => emit(
            state.copyWith(isSaving: false, errorMessage: failure.message)),
        (_) => emit(state.copyWith(isSaving: false, saved: true)),
      );
    } else {
      final result = await _addTransactionUseCase(transaction);
      result.fold(
        (failure) => emit(
            state.copyWith(isSaving: false, errorMessage: failure.message)),
        (_) => emit(state.copyWith(isSaving: false, saved: true)),
      );
    }
  }
}
