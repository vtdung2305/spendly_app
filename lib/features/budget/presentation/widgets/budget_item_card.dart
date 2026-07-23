import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadow.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../transactions/presentation/mappers/expense_category_ui.dart';
import '../../domain/entities/budget_item.dart';

/// Per-category budget row — flips to danger-tint bg + red border + red bar
/// when [BudgetItem.isOverBudget], per design handoff.
class BudgetItemCard extends StatelessWidget {
  const BudgetItemCard({required this.item, super.key});

  final BudgetItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final over = item.isOverBudget;
    final pctColor = over ? colors.danger : colors.textPrimary;
    final barColor = over ? colors.danger : item.category.ownColor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      decoration: BoxDecoration(
        color: over ? colors.dangerTint : colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: over ? colors.danger : colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.category.icon, size: 20, color: item.category.ownColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(item.category.label, style: Theme.of(context).textTheme.titleSmall),
              ),
              Text(
                '${item.usedPercent}%',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: pctColor, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: (item.usedPercent / 100).clamp(0, 1),
              minHeight: 8,
              backgroundColor: colors.surfaceAlt,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.format(item.usedAmount),
                style: AppTypography.mono(fontSize: 11, fontWeight: FontWeight.w400, color: colors.textSecondary),
              ),
              Text(
                '/ ${CurrencyFormatter.format(item.budgetAmount)}',
                style: AppTypography.mono(fontSize: 11, fontWeight: FontWeight.w400, color: colors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
