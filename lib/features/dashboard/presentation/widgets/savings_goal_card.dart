import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';

/// "Mục tiêu tiết kiệm {year}" progress card — tap opens the goal-amount
/// editor, per design handoff.
class SavingsGoalCard extends StatelessWidget {
  const SavingsGoalCard({
    required this.current,
    required this.goal,
    required this.onTap,
    super.key,
  });

  final double current;
  final double goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percent =
        goal <= 0 ? 0.0 : (current / goal * 100).clamp(0, 999).toDouble();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.mdLg),
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
              children: [
                Icon(Icons.flag_rounded, size: 20, color: colors.success),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    context.l10n.dashboardSavingsGoalTitle(
                        DateTime.now().year.toString()),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontSize: 14),
                  ),
                ),
                Text(
                  '${percent.round()}%',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colors.success),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.smMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0, 1),
                minHeight: 8,
                backgroundColor: colors.surfaceAlt,
                valueColor: AlwaysStoppedAnimation(colors.success),
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormatter.format(current),
                  style: AppTypography.mono(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary),
                ),
                Text(
                  '/ ${CurrencyFormatter.format(goal)}',
                  style: AppTypography.mono(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colors.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
