import 'package:flutter/material.dart';

import '../../../../core/theme/app_animation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadow.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../transactions/domain/entities/report_summary.dart';

/// "Chi tiêu theo tuần" — 4 labeled bars (T1-T4), per Reports layout.
class WeeklyBarCard extends StatelessWidget {
  const WeeklyBarCard({required this.bars, super.key});

  final List<WeekBar> bars;

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
          Text('Chi tiêu theo tuần', style: Theme.of(context).textTheme.titleSmall),
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
                                        borderRadius: BorderRadius.circular(AppRadius.sm / 2),
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
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
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
