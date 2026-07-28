import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';

/// Reference "current month" for the mock data — matches the hardcoded
/// July 2026 used elsewhere (Dashboard/Calendar).
final _kReferenceMonth = DateTime(2026, 7);

/// Horizontal scrollable month chips; active = Primary fill. Per design
/// handoff, these are decorative — selecting one doesn't refilter the list.
class MonthChipsRow extends StatelessWidget {
  const MonthChipsRow(
      {required this.selectedIndex, required this.onSelected, super.key});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final monthLabels = [
      for (var i = 0; i < 4; i++)
        DateFormat.MMM(locale).format(
            DateTime(_kReferenceMonth.year, _kReferenceMonth.month - i)),
    ];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: monthLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? colors.primary : colors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              alignment: Alignment.center,
              child: Text(
                monthLabels[index],
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 12,
                      color: isActive ? Colors.white : colors.textSecondary,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
