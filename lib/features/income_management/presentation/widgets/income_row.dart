import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// 42px rounded-12 success-tint icon tile + label + date, amount `+X` green,
/// per Income Management layout — no category label (unlike TransactionRow).
/// Card bg + no shadow, matching `cardStyle` (`box-shadow:none`) per design.
class IncomeRow extends StatelessWidget {
  const IncomeRow({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
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
              color: colors.successTint,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
                transaction.category == null
                    ? Icons.category_rounded
                    : categoryIconFor(transaction.category!.iconName),
                size: 20,
                color: colors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note ?? transaction.displayLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge
                      ?.copyWith(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd/MM/yyyy').format(transaction.date),
                  style: textTheme.bodySmall
                      ?.copyWith(color: colors.textTertiary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Text(
            '+${CurrencyFormatter.formatPlain(transaction.amount)} ₫',
            style: AppTypography.mono(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: colors.success),
          ),
        ],
      ),
    );
  }
}
