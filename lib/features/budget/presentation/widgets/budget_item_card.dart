import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/transactions/presentation/mappers/expense_category_ui.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';

/// Per-category budget row — flips to danger-tint bg + red border + red bar
/// when [BudgetItem.isOverBudget], per design handoff.
class BudgetItemCard extends StatelessWidget {
  const BudgetItemCard({required this.item, super.key, this.onTap});

  final BudgetItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final over = item.isOverBudget;
    final pctColor = over ? colors.danger : colors.textPrimary;
    final barColor = over ? colors.danger : item.category.ownColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
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
                Icon(item.category.icon,
                    size: 20, color: item.category.ownColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.category.labelText(context),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  context.l10n.percentValue(item.usedPercent.toString()),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: pctColor),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: colors.textTertiary),
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
                  style: AppTypography.mono(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary),
                ),
                Text(
                  context.l10n.budgetItemOfTotal(
                      CurrencyFormatter.format(item.budgetAmount)),
                  style: AppTypography.mono(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colors.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
