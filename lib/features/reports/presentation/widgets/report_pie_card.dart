import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/charts/donut_chart.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';
import 'package:spendly_app/features/transactions/presentation/mappers/chart_category_group_ui.dart';

/// "Theo danh mục" donut + legend, per Reports layout (104px donut, tighter
/// legend spacing than Dashboard's equivalent card).
class ReportPieCard extends StatelessWidget {
  const ReportPieCard({required this.breakdown, super.key});

  final List<CategoryShare> breakdown;

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
          Text(context.l10n.reportsPieCardTitle,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DonutChart(
                size: 104,
                strokeWidth: 18,
                slices: [
                  for (final share in breakdown)
                    DonutSlice(
                        color: share.group.color, percent: share.percent),
                ],
              ),
              const SizedBox(width: AppSpacing.lgXl),
              Expanded(
                child: Column(
                  children: [
                    for (final share in breakdown)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(
                              height: 7,
                              width: 7,
                              decoration: BoxDecoration(
                                  color: share.group.color,
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                share.group.labelText(context),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: colors.textSecondary,
                                        fontSize: 11.5),
                              ),
                            ),
                            Text(
                              context.l10n.percentValue(
                                  share.percent.round().toString()),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
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
