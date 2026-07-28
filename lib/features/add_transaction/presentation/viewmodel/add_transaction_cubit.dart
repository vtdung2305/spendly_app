import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/transactions/domain/entities/expense_category.dart';
import 'package:spendly_app/features/transactions/domain/entities/income_source.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit(
    this._addTransactionUseCase,
    this._updateTransactionUseCase, {
    TransactionType initialTab = TransactionType.expense,
    Transaction? existingTransaction,
  })  : _existingTransaction = existingTransaction,
        super(
          existingTransaction != null
              ? AddTransactionState(
                  type: existingTransaction.type,
                  expenseCategory: existingTransaction.expenseCategory,
                  incomeSource: existingTransaction.incomeSource,
                  amount: existingTransaction.amount,
                  date: existingTransaction.date,
                  note: existingTransaction.note ?? '',
                )
              : AddTransactionState(type: initialTab, date: DateTime.now()),
        );

  final AddTransactionUseCase _addTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final Transaction? _existingTransaction;

  bool get isEditing => _existingTransaction != null;
  double get initialAmount => _existingTransaction?.amount ?? 0;
  String get initialNote => _existingTransaction?.note ?? '';

  void selectTab(TransactionType type) {
    emit(state.copyWith(type: type));
  }

  void selectExpenseCategory(ExpenseCategory category) {
    emit(state.copyWith(expenseCategory: category));
  }

  void selectIncomeSource(IncomeSource source) {
    emit(state.copyWith(incomeSource: source));
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
      expenseCategory:
          state.type == TransactionType.expense ? state.expenseCategory : null,
      incomeSource:
          state.type == TransactionType.income ? state.incomeSource : null,
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
