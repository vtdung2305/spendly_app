import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// Shared list row for Dashboard "Recent Transactions" and Transaction
/// History — 42px rounded-12 icon tile + name + "category · date" + amount.
/// No shadow/radius-20 (`cardStyle` with `box-shadow:none`), per design.
class TransactionRow extends StatelessWidget {
  const TransactionRow({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final isIncome = transaction.type == TransactionType.income;
    final tintColor = isIncome ? colors.successTint : colors.primaryTint;
    final iconColor = isIncome ? colors.success : colors.primary;
    final icon = transaction.category == null
        ? Icons.category_rounded
        : categoryIconFor(transaction.category!.iconName);
    final amountColor = isIncome ? colors.success : colors.danger;
    final amountPrefix = isIncome ? '+' : '-';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: tintColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note?.isNotEmpty == true
                      ? transaction.note!
                      : transaction.displayLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.displayLabel} · ${DateFormat('dd/MM').format(transaction.date)}',
                  style: textTheme.bodySmall
                      ?.copyWith(color: colors.textTertiary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Text(
            '$amountPrefix${CurrencyFormatter.formatPlain(transaction.amount)} ₫',
            style: AppTypography.mono(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: amountColor),
          ),
        ],
      ),
    );
  }
}
