import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/domain/entities/expense_category.dart';
import '../../../transactions/domain/entities/income_source.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/usecases/add_transaction_usecase.dart';
import 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit(this._addTransactionUseCase, {TransactionType initialTab = TransactionType.expense})
      : super(AddTransactionState(type: initialTab, date: DateTime.now()));

  final AddTransactionUseCase _addTransactionUseCase;

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
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: state.type,
      amount: state.amount,
      date: state.date ?? DateTime.now(),
      expenseCategory: state.type == TransactionType.expense ? state.expenseCategory : null,
      incomeSource: state.type == TransactionType.income ? state.incomeSource : null,
      note: state.note.isEmpty ? null : state.note,
    );

    final result = await _addTransactionUseCase(transaction);
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, saved: true)),
    );
  }
}
