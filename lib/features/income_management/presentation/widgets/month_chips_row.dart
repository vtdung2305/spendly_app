import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

const _kMonthLabels = ['Th.7', 'Th.6', 'Th.5', 'Th.4'];

/// Horizontal scrollable month chips; active = Primary fill. Per design
/// handoff, these are decorative — selecting one doesn't refilter the list.
class MonthChipsRow extends StatelessWidget {
  const MonthChipsRow({required this.selectedIndex, required this.onSelected, super.key});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _kMonthLabels.length,
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
                _kMonthLabels[index],
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
