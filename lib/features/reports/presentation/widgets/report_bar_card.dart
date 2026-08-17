import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_animation.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_summary.dart';

/// Period-aware bar chart card — title and bucket count/labels change with
/// the selected [period] (daily bars for week, weekly for month, quarterly
/// for year).
class ReportBarCard extends StatelessWidget {
  const ReportBarCard({required this.period, required this.bars, super.key});

  final ReportPeriod period;
  final List<ChartBar> bars;

  String _titleFor(BuildContext context) => switch (period) {
        ReportPeriod.week => context.l10n.reportsChartTitleWeek,
        ReportPeriod.month => context.l10n.reportsChartTitleMonth,
        ReportPeriod.year => context.l10n.reportsChartTitleYear,
      };

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
          Text(_titleFor(context), style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.mdLg),
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bar in bars)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: bar.percent / 100),
                                duration: AppAnimation.chartValue,
                                curve: Curves.easeOut,
                                builder: (context, value, _) {
                                  return FractionallySizedBox(
                                    heightFactor: value.clamp(0.04, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colors.primary,
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.sm / 2),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            bar.label,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
