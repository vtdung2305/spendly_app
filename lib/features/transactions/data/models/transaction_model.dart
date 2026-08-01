import 'package:spendly_app/core/utils/num_parsing.dart';
import 'package:spendly_app/features/category_management/data/models/category_model.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// DTO for the Supabase `transactions` table row.
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.categoryId,
    this.note,
    this.embeddedCategory,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      amount: parseNum(json['amount']),
      date: DateTime.parse(json['date'] as String),
      categoryId: json['category_id'] as String?,
      note: json['note'] as String?,
    );
  }

  /// Maps the custom backend's transaction shape (camelCase, `occurredAt`
  /// instead of `date`, `type` upper-cased) — every row embeds its full
  /// `category` object, so no separate id→Category lookup is needed here
  /// (unlike Supabase mode).
  factory TransactionModel.fromBackendJson(Map<String, dynamic> json) {
    final categoryJson = json['category'] as Map<String, dynamic>?;
    return TransactionModel(
      id: json['id'] as String,
      type: (json['type'] as String) == 'INCOME'
          ? TransactionType.income
          : TransactionType.expense,
      amount: parseNum(json['amount']),
      date: DateTime.parse(json['occurredAt'] as String),
      categoryId: json['categoryId'] as String?,
      note: json['note'] as String?,
      embeddedCategory: categoryJson == null
          ? null
          : CategoryModel.fromBackendJson(categoryJson).toEntity(),
    );
  }

  factory TransactionModel.fromEntity(Transaction entity) => TransactionModel(
        id: entity.id,
        type: entity.type,
        amount: entity.amount,
        date: entity.date,
        categoryId: entity.category?.id,
        note: entity.note,
      );

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String? categoryId;
  final String? note;

  /// Populated only by [fromBackendJson] — the resolved `Category` embedded
  /// directly in the backend's response row.
  final Category? embeddedCategory;

  Map<String, dynamic> toJson() => {
        'id': id,
        ...toInsertJson(),
      };

  /// Excludes `id` — the DB generates it via `gen_random_uuid()` default.
  Map<String, dynamic> toInsertJson() => {
        'type': type.name,
        'amount': amount,
        'date': '${date.year.toString().padLeft(4, '0')}-'
            '${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')}',
        'category_id': categoryId,
        'note': note,
      };

  /// Backend `POST`/`PATCH transactions` body — `occurredAt` instead of
  /// `date`, `type` upper-cased, `categoryId` camelCase. `type` is
  /// immutable on the backend, so `PATCH` calls pass `includeType: false`
  /// to omit it.
  Map<String, dynamic> toBackendJson({bool includeType = true}) => {
        if (includeType)
          'type': type == TransactionType.income ? 'INCOME' : 'EXPENSE',
        'categoryId': categoryId,
        'amount': amount,
        'note': note,
        'occurredAt': '${date.year.toString().padLeft(4, '0')}-'
            '${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')}',
      };

  /// [category] is looked up by [categoryId] from a pre-fetched map — null
  /// only if the category was deleted without reassignment (shouldn't
  /// normally happen; `deleteCategory` reassigns to "Khác" first).
  Transaction toEntity(Category? category) => Transaction(
        id: id,
        type: type,
        amount: amount,
        date: date,
        category: category,
        note: note,
      );
}
