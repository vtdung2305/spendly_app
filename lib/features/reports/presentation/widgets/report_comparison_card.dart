import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_summary.dart';

/// Income vs. expense comparison card — delta vs. previous period, and a
/// progress bar of how much of the period's income has been spent.
class ReportComparisonCard extends StatelessWidget {
  const ReportComparisonCard({required this.summary, super.key});

  final ReportSummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _AmountColumn(
                  icon: Icons.arrow_downward,
                  iconColor: colors.success,
                  label: l10n.reportsComparisonIncomeLabel,
                  amount: summary.totalIncome,
                  deltaPercent: summary.incomeDeltaPercent,
                  isGoodWhenPositive: true,
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: colors.border,
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.smMd),
              ),
              Expanded(
                child: _AmountColumn(
                  icon: Icons.arrow_upward,
                  iconColor: colors.danger,
                  label: l10n.reportsComparisonExpenseLabel,
                  amount: summary.totalExpense,
                  deltaPercent: summary.expenseDeltaPercent,
                  isGoodWhenPositive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.mdLg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: summary.expensePercentOfIncome / 100,
              minHeight: 8,
              backgroundColor: colors.successTint,
              valueColor: AlwaysStoppedAnimation(colors.danger),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.reportsComparisonUsedPercent(
                    summary.expensePercentOfIncome.toString()),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.textTertiary, fontSize: 11.5),
              ),
              Text(
                l10n.reportsComparisonSavings(
                    CurrencyFormatter.format(summary.netSavings)),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountColumn extends StatelessWidget {
  const _AmountColumn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
    required this.deltaPercent,
    required this.isGoodWhenPositive,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final double amount;
  final double? deltaPercent;
  final bool isGoodWhenPositive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final delta = deltaPercent;
    final isGood =
        delta == null ? true : (delta >= 0) == isGoodWhenPositive;
    final deltaColor = isGood ? colors.success : colors.danger;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.textSecondary, fontSize: 11.5),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          CurrencyFormatter.format(amount),
          style: AppTypography.mono(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          delta == null
              ? l10n.reportsComparisonNoPreviousData
              : l10n.reportsComparisonVsPrevious(
                  '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)}%'),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: delta == null ? colors.textTertiary : deltaColor,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}
