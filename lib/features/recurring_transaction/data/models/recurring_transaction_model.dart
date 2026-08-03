import 'package:spendly_app/core/utils/num_parsing.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// DTO for the custom backend's `/api/v1/recurring-transactions` shape.
/// The embedded `category` object has no `type` field of its own (unlike
/// `/categories`), so [category] is built from the row's own [type]
/// instead of `CategoryModel.fromBackendJson`.
class RecurringTransactionModel {
  const RecurringTransactionModel({
    required this.id,
    required this.type,
    required this.category,
    required this.label,
    required this.amount,
    required this.dayOfMonth,
    required this.isActive,
  });

  factory RecurringTransactionModel.fromBackendJson(
      Map<String, dynamic> json) {
    final type = (json['type'] as String) == 'INCOME'
        ? TransactionType.income
        : TransactionType.expense;
    final categoryJson = json['category'] as Map<String, dynamic>;
    return RecurringTransactionModel(
      id: json['id'] as String,
      type: type,
      category: Category(
        id: categoryJson['id'] as String,
        label: categoryJson['name'] as String,
        iconName: categoryJson['icon'] as String,
        colorHex: categoryJson['color'] as String,
        type: type == TransactionType.income
            ? CategoryType.income
            : CategoryType.expense,
      ),
      label: json['label'] as String,
      amount: parseNum(json['amount']),
      dayOfMonth: parseNum(json['dayOfMonth']).toInt(),
      isActive: json['isActive'] as bool,
    );
  }

  final String id;
  final TransactionType type;
  final Category category;
  final String label;
  final double amount;
  final int dayOfMonth;
  final bool isActive;

  RecurringTransaction toEntity() => RecurringTransaction(
        id: id,
        type: type,
        category: category,
        label: label,
        amount: amount,
        dayOfMonth: dayOfMonth,
        isActive: isActive,
      );
}
