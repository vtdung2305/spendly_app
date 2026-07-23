import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart';
import '../mappers/expense_category_ui.dart';
import '../mappers/income_source_ui.dart';

/// Shared list row for Dashboard "Recent Transactions" and Transaction
/// History — 42px rounded-12 icon tile + name + "category · date" + amount.
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
    final icon = isIncome ? transaction.incomeSource!.icon : transaction.expenseCategory!.icon;
    final amountColor = isIncome ? colors.success : colors.danger;
    final amountPrefix = isIncome ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                  style: textTheme.bodySmall?.copyWith(color: colors.textTertiary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Text(
            '$amountPrefix${CurrencyFormatter.formatPlain(transaction.amount)}',
            style: AppTypography.mono(fontSize: 13.5, fontWeight: FontWeight.w700, color: amountColor),
          ),
        ],
      ),
    );
  }
}
