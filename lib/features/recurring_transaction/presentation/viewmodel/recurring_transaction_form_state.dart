import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// Form state for both Add and Edit Recurring Transaction (screen 10c) —
/// Save is enabled only once [isValid], per design.
class RecurringTransactionFormState extends Equatable {
  const RecurringTransactionFormState({
    this.type = TransactionType.expense,
    this.category,
    this.label = '',
    this.amount = 0,
    this.dayOfMonth = 1,
    this.isActive = true,
    this.expenseCategories = const [],
    this.incomeCategories = const [],
    this.isSaving = false,
    this.saved = false,
    this.deleted = false,
    this.errorMessage,
  });

  final TransactionType type;
  final Category? category;
  final String label;
  final double amount;
  final int dayOfMonth;
  final bool isActive;

  final List<Category> expenseCategories;
  final List<Category> incomeCategories;

  final bool isSaving;
  final bool saved;
  final bool deleted;
  final String? errorMessage;

  bool get isValid => label.trim().isNotEmpty && amount > 0 && category != null;

  RecurringTransactionFormState copyWith({
    TransactionType? type,
    Category? category,
    String? label,
    double? amount,
    int? dayOfMonth,
    bool? isActive,
    List<Category>? expenseCategories,
    List<Category>? incomeCategories,
    bool? isSaving,
    bool? saved,
    bool? deleted,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearCategory = false,
  }) {
    return RecurringTransactionFormState(
      type: type ?? this.type,
      category: clearCategory ? null : category ?? this.category,
      label: label ?? this.label,
      amount: amount ?? this.amount,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      isActive: isActive ?? this.isActive,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      incomeCategories: incomeCategories ?? this.incomeCategories,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      deleted: deleted ?? this.deleted,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        type,
        category,
        label,
        amount,
        dayOfMonth,
        isActive,
        expenseCategories,
        incomeCategories,
        isSaving,
        saved,
        deleted,
        errorMessage,
      ];
}
