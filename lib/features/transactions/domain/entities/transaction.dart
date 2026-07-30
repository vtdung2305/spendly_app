import 'package:spendly_app/features/category_management/domain/entities/category.dart';

enum TransactionType { expense, income }

/// A single income/expense entry, categorized by a dynamic [Category]
/// (expense-typed for [TransactionType.expense], income-typed otherwise).
class Transaction {
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.category,
    this.note,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final Category? category;
  final String? note;

  String get displayLabel => category?.label ?? '';
}
