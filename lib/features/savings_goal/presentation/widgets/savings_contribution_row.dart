import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';

/// One "Đóng góp tháng X" row in the Savings Goal detail's history list —
/// net (income − expense) for that month, colored danger when negative.
class SavingsContributionRow extends StatelessWidget {
  const SavingsContributionRow({required this.contribution, super.key});

  final SavingsContribution contribution;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive = contribution.amount >= 0;
    final tintColor = isPositive ? colors.success : colors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.mdLg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isPositive ? colors.successTint : colors.dangerTint,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.savings_rounded, size: 20, color: tintColor),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.savingsGoalDetailContributionMonth(
                      contribution.month.toString()),
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd/MM/yyyy').format(contribution.date),
                  style:
                      TextStyle(fontSize: 11.5, color: colors.textTertiary),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${CurrencyFormatter.format(contribution.amount)}',
            style: AppTypography.mono(
                fontSize: 13.5, fontWeight: FontWeight.w700, color: tintColor),
          ),
        ],
      ),
    );
  }
}
