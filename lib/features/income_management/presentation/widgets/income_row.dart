import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/mappers/income_source_ui.dart';

/// 42px rounded-12 success-tint icon tile + label + date, amount `+X` green,
/// per Income Management layout — no category label (unlike TransactionRow).
class IncomeRow extends StatelessWidget {
  const IncomeRow({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: colors.successTint,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(transaction.incomeSource!.icon, size: 20, color: colors.success),
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
                  style: textTheme.bodyLarge?.copyWith(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd/MM/yyyy').format(transaction.date),
                  style: textTheme.bodySmall?.copyWith(color: colors.textTertiary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Text(
            '+${CurrencyFormatter.formatPlain(transaction.amount)} ₫',
            style: AppTypography.mono(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.success),
          ),
        ],
      ),
    );
  }
}
