import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

/// 4-button quick-action row ("Ghi chi"/"Ghi thu"/"Lịch sử"/"Báo cáo"), per
/// Dashboard layout — shortcuts to the most common actions.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    required this.onAddExpense,
    required this.onAddIncome,
    required this.onHistory,
    required this.onReports,
    super.key,
  });

  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;
  final VoidCallback onHistory;
  final VoidCallback onReports;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.remove_circle_rounded,
            label: context.l10n.dashboardQuickActionExpense,
            color: colors.danger,
            onTap: onAddExpense,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _QuickAction(
            icon: Icons.add_circle_rounded,
            label: context.l10n.dashboardQuickActionIncome,
            color: colors.success,
            onTap: onAddIncome,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _QuickAction(
            icon: Icons.receipt_long_rounded,
            label: context.l10n.dashboardQuickActionHistory,
            color: colors.primary,
            onTap: onHistory,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _QuickAction(
            icon: Icons.bar_chart_rounded,
            label: context.l10n.reportsTitle,
            color: colors.warning,
            onTap: onReports,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
