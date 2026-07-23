import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Bottom sheet listing a tapped day's transactions with inline edit/delete
/// icon actions, per design handoff Calendar interaction.
class DayTransactionsSheet extends StatelessWidget {
  const DayTransactionsSheet({required this.day, required this.month, required this.amount, super.key});

  final int day;
  final int month;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal, AppSpacing.md, AppSpacing.screenHorizontal, AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 36,
              decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(AppRadius.full)),
            ),
          ),
          const SizedBox(height: AppSpacing.smMd),
          Text(
            'Giao dịch ngày $day/$month',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.smMd),
          if (amount <= 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.mdLg),
              child: Text(
                'Không có giao dịch trong ngày này',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_long_rounded, size: 18, color: colors.danger),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('Chi tiêu trong ngày', style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Text(
                    '-${CurrencyFormatter.formatPlain(amount)}',
                    style: AppTypography.mono(fontSize: 13, fontWeight: FontWeight.w700, color: colors.danger),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(Icons.edit_rounded, size: 16, color: colors.textTertiary),
                  const SizedBox(width: AppSpacing.xxs),
                  Icon(Icons.delete_rounded, size: 16, color: colors.danger),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
