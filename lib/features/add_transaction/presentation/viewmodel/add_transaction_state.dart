import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/expense_category.dart';
import '../../../transactions/domain/entities/income_source.dart';
import '../../../transactions/domain/entities/transaction.dart';

/// Form state for the unified Add Expense/Income screen. Save button is
/// enabled only once [isValid] — category/source AND amount set, per design.
class AddTransactionState extends Equatable {
  const AddTransactionState({
    this.type = TransactionType.expense,
    this.expenseCategory,
    this.incomeSource,
    this.amount = 0,
    this.date,
    this.note = '',
    this.isSaving = false,
    this.saved = false,
    this.errorMessage,
  });

  final TransactionType type;
  final ExpenseCategory? expenseCategory;
  final IncomeSource? incomeSource;
  final double amount;
  final DateTime? date;
  final String note;
  final bool isSaving;
  final bool saved;
  final String? errorMessage;

  bool get isValid =>
      amount > 0 &&
      (type == TransactionType.expense ? expenseCategory != null : incomeSource != null);

  AddTransactionState copyWith({
    TransactionType? type,
    ExpenseCategory? expenseCategory,
    IncomeSource? incomeSource,
    double? amount,
    DateTime? date,
    String? note,
    bool? isSaving,
    bool? saved,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AddTransactionState(
      type: type ?? this.type,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      incomeSource: incomeSource ?? this.incomeSource,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        type,
        expenseCategory,
        incomeSource,
        amount,
        date,
        note,
        isSaving,
        saved,
        errorMessage,
      ];
}
