import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/weekday_labels.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';

/// Shared month-calendar layout — weekday header row + leading blank cells +
/// one cell per day of [month], in the same 7-column grid (6px gaps) used by
/// both the Calendar screen and the Add Transaction date picker. Cell
/// appearance is fully owned by [dayBuilder] so callers can style
/// selection/spend-amount differently while sharing the exact same layout.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    required this.month,
    required this.daysInMonth,
    required this.dayBuilder,
    super.key,
  });

  final DateTime month;
  final int daysInMonth;
  final Widget Function(int day) dayBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final leadingBlanks = DateTime(month.year, month.month).weekday - 1;

    return Column(
      children: [
        // Kept out of the GridView below — GridView.count forces every
        // child (including this header row) into the same square aspect
        // ratio as the day cells, which left a large empty gap above the
        // centered weekday labels.
        Row(
          children: [
            for (final label in weekdayLabels(context))
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textTertiary),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          children: [
            for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
            for (var day = 1; day <= daysInMonth; day++) dayBuilder(day),
          ],
        ),
      ],
    );
  }
}

/// Rounded-square day cell shared by the Calendar screen's grid and the Add
/// Transaction date picker — 12px radius, optional 2px ring (e.g. "today"),
/// per design handoff. Colors/content are caller-owned so the same shape
/// backs both the spend-tone cells (Calendar) and the selection cells (date
/// picker).
class MonthGridDayCell extends StatelessWidget {
  const MonthGridDayCell({
    required this.onTap,
    required this.background,
    required this.child,
    this.ringColor,
    super.key,
  });

  final VoidCallback onTap;
  final Color background;
  final Color? ringColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: ringColor != null
              ? Border.all(color: ringColor!, width: 2)
              : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}
