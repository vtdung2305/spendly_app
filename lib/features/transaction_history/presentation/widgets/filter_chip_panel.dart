import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

/// Expandable "Lọc theo" panel — chips are decorative per design handoff
/// (Date/Category/Amount/Type filters, no live re-filtering wired in mock).
class FilterChipPanel extends StatelessWidget {
  const FilterChipPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filterChips = [
      context.l10n.historyFilterChipThisWeek,
      context.l10n.historyFilterChipFoodDrink,
      context.l10n.historyFilterChipOver500k,
      context.l10n.historyFilterChipExpenseOnly,
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.historyFilterSectionLabel,
            style:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final label in filterChips)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.smMd, vertical: 7),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 11.5, color: colors.textPrimary),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
