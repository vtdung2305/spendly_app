import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/charts/progress_ring.dart';

/// Tappable row: budget ring + "Đã dùng X% · còn Y ₫" + chevron, per
/// Dashboard layout row 3 (navigates to Budget screen).
class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    required this.usedPercent,
    required this.remaining,
    required this.onTap,
    super.key,
  });

  final int usedPercent;
  final double remaining;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colors.border),
            boxShadow: AppShadow.card,
          ),
          child: Row(
            children: [
              ProgressRing(
                percent: usedPercent.toDouble(),
                progressColor: colors.primary,
                trackColor: colors.surfaceAlt,
                size: 52,
                strokeWidth: 6,
                centerLabel: Text(
                  context.l10n.percentValue(usedPercent.toString()),
                  style: textTheme.labelLarge
                      ?.copyWith(fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.dashboardBudgetCardTitle,
                        style: textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.dashboardBudgetUsedSummary(
                        usedPercent.toString(),
                        CurrencyFormatter.format(remaining),
                      ),
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
