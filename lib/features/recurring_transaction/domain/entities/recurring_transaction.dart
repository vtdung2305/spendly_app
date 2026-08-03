import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// A fixed monthly charge/deposit (rent, subscription, salary...) the
/// backend auto-generates into a real [Transaction] on [dayOfMonth] of
/// every month while [isActive] — screens 10b/10c.
class RecurringTransaction extends Equatable {
  const RecurringTransaction({
    required this.id,
    required this.type,
    required this.category,
    required this.label,
    required this.amount,
    required this.dayOfMonth,
    required this.isActive,
  });

  final String id;
  final TransactionType type;
  final Category category;
  final String label;
  final double amount;

  /// 1-28 — capped below 29 so every month (including February) has that
  /// day, per the backend contract.
  final int dayOfMonth;
  final bool isActive;

  @override
  List<Object?> get props =>
      [id, type, category, label, amount, dayOfMonth, isActive];
}
