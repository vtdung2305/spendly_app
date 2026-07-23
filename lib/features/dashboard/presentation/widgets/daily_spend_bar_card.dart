import 'package:flutter/material.dart';

import '../../../../core/theme/app_animation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadow.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../transactions/domain/entities/dashboard_summary.dart';

const _kLowSpendThreshold = 300000.0;
const _kHighSpendThreshold = 1000000.0;

/// Title + 14 thin vertical bars, color-coded green(low)/primary(mid)/red(high),
/// per Dashboard layout row 5.
class DailySpendBarCard extends StatelessWidget {
  const DailySpendBarCard({required this.points, super.key});

  final List<DailySpendPoint> points;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxValue = points.fold<double>(1, (m, p) => p.total > m ? p.total : m);

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
          Text('Chi tiêu theo ngày', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.mdLg),
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final point in points)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: point.total / maxValue),
                        duration: AppAnimation.chartValue,
                        curve: Curves.easeOut,
                        builder: (context, value, _) {
                          return FractionallySizedBox(
                            heightFactor: value.clamp(0.04, 1.0),
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _colorFor(point.total, colors),
                                borderRadius: BorderRadius.circular(AppRadius.sm / 3),
                              ),
                            ),
                          );
                        },
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

  Color _colorFor(double total, AppColorsExtension colors) {
    if (total <= _kLowSpendThreshold) return colors.success;
    if (total >= _kHighSpendThreshold) return colors.danger;
    return colors.primary;
  }
}
