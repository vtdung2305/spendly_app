import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// "Xin chào 👋 / Minh Anh" greeting + month chip, per Dashboard layout row 1.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.userName, required this.monthLabel, super.key});

  final String userName;
  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào 👋',
              style: textTheme.bodySmall?.copyWith(color: colors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(userName, style: textTheme.titleLarge?.copyWith(fontSize: 19)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd, vertical: 7),
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            monthLabel,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}
