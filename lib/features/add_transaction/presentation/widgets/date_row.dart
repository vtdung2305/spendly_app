import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

/// "Ngày" label (left) + small date pill (right, icon + "Hôm nay, dd/MM"),
/// per Add Transaction layout — NOT a full bordered row.
class DateRow extends StatelessWidget {
  const DateRow({required this.date, required this.onTap, super.key});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final label = isToday
        ? 'Hôm nay, ${DateFormat('dd/MM').format(date)}'
        : DateFormat('dd/MM/yyyy').format(date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Ngày', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 13)),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm - 2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.sm - 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_rounded, size: 16, color: colors.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
