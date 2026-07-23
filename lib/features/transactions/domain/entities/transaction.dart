import 'expense_category.dart';
import 'income_source.dart';

enum TransactionType { expense, income }

/// A single income/expense entry. Exactly one of [expenseCategory] /
/// [incomeSource] is non-null, matching [type].
class Transaction {
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.expenseCategory,
    this.incomeSource,
    this.note,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final ExpenseCategory? expenseCategory;
  final IncomeSource? incomeSource;
  final String? note;

  String get displayLabel =>
      type == TransactionType.expense ? expenseCategory!.label : incomeSource!.label;
}
