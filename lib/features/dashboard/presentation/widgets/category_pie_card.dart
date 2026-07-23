import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadow.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/components/charts/donut_chart.dart';
import '../../../transactions/domain/entities/dashboard_summary.dart';
import '../../../transactions/presentation/mappers/chart_category_group_ui.dart';

/// Title + donut (category breakdown) + legend list, per Dashboard layout row 4.
class CategoryPieCard extends StatelessWidget {
  const CategoryPieCard({required this.breakdown, required this.total, super.key});

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
          Text('Chi tiêu theo danh mục', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.mdLg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DonutChart(
                size: 120,
                strokeWidth: 20,
                slices: [
                  for (final share in breakdown)
                    DonutSlice(color: share.group.color, percent: share.percent),
                ],
                centerLabel: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CurrencyFormatter.formatCompact(total),
                      style: AppTypography.mono(
                        fontSize: 15, fontWeight: FontWeight.w800, color: colors.textPrimary,
                      ),
                    ),
                    Text('tổng chi', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
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

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.share});
  final CategoryShare share;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(color: share.group.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(share.group.label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(
            '${share.percent.round()}%',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
