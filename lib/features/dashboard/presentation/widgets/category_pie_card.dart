import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/charts/donut_chart.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';

/// Title + donut (category breakdown) + legend list, per Dashboard layout row 4.
class CategoryPieCard extends StatelessWidget {
  const CategoryPieCard(
      {required this.breakdown, required this.total, super.key});

  final List<CategoryShare> breakdown;
  final double total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
          Text(context.l10n.dashboardCategoryPieTitle,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.mdLg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DonutChart(
                size: 120,
                strokeWidth: 20,
                slices: [
                  for (final share in breakdown)
                    DonutSlice(
                        color: _colorFor(colors, share),
                        percent: share.percent),
                ],
                centerLabel: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CurrencyFormatter.formatCompact(total),
                      style: AppTypography.mono(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      context.l10n.dashboardCategoryPieCenterLabel,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lgXl),
              Expanded(
                child: Column(
                  children: [
                    for (final share in breakdown) _LegendRow(share: share),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _colorFor(AppColorsExtension colors, CategoryShare share) =>
    share.isOther || share.category == null
        ? colors.textTertiary
        : categoryColorFromHex(share.category!.colorHex);

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.share});
  final CategoryShare share;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = _colorFor(colors, share);
    final label = share.isOther || share.category == null
        ? context.l10n.categoryOther
        : share.category!.label;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(
            context.l10n.percentValue(share.percent.round().toString()),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.textPrimary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
