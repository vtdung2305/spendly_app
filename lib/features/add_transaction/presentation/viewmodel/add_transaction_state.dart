import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// Form state for the unified Add Expense/Income screen. Save button is
/// enabled only once [isValid] — category AND amount set, per design.
class AddTransactionState extends Equatable {
  const AddTransactionState({
    this.type = TransactionType.expense,
    this.category,
    this.amount = 0,
    this.date,
    this.note = '',
    this.expenseCategories = const [],
    this.incomeCategories = const [],
    this.isSaving = false,
    this.saved = false,
    this.errorMessage,
  });

  final TransactionType type;
  final Category? category;
  final double amount;
  final DateTime? date;
  final String note;

  /// Loaded once via `GetCategoriesUseCase`, split by type — feeds the
  /// picker grid for whichever tab is active.
  final List<Category> expenseCategories;
  final List<Category> incomeCategories;

  final bool isSaving;
  final bool saved;
  final String? errorMessage;

  bool get isValid => amount > 0 && category != null;

  AddTransactionState copyWith({
    TransactionType? type,
    Category? category,
    double? amount,
    DateTime? date,
    String? note,
    List<Category>? expenseCategories,
    List<Category>? incomeCategories,
    bool? isSaving,
    bool? saved,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearCategory = false,
  }) {
    return AddTransactionState(
      type: type ?? this.type,
      category: clearCategory ? null : category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      incomeCategories: incomeCategories ?? this.incomeCategories,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        type,
        category,
        amount,
        date,
        note,
        expenseCategories,
        incomeCategories,
        isSaving,
        saved,
        errorMessage,
      ];
}
