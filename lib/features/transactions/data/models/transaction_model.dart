import '../../domain/entities/expense_category.dart';
import '../../domain/entities/income_source.dart';
import '../../domain/entities/transaction.dart';

/// DTO for the Supabase `transactions` table row.
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.expenseCategory,
    this.incomeSource,
    this.note,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final type = TransactionType.values.byName(json['type'] as String);
    return TransactionModel(
      id: json['id'] as String,
      type: type,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      expenseCategory: json['expense_category'] == null
          ? null
          : ExpenseCategory.values.byName(json['expense_category'] as String),
      incomeSource: json['income_source'] == null
          ? null
          : IncomeSource.values.byName(json['income_source'] as String),
      note: json['note'] as String?,
    );
  }

  factory TransactionModel.fromEntity(Transaction entity) => TransactionModel(
        id: entity.id,
        type: entity.type,
        amount: entity.amount,
        date: entity.date,
        expenseCategory: entity.expenseCategory,
        incomeSource: entity.incomeSource,
        note: entity.note,
      );

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final ExpenseCategory? expenseCategory;
  final IncomeSource? incomeSource;
  final String? note;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'date': date.toIso8601String(),
        'expense_category': expenseCategory?.name,
        'income_source': incomeSource?.name,
        'note': note,
      };

  Transaction toEntity() => Transaction(
        id: id,
        type: type,
        amount: amount,
        date: date,
        expenseCategory: expenseCategory,
        incomeSource: incomeSource,
        note: note,
      );
}
