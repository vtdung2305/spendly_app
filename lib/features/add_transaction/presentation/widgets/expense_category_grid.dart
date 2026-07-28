import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/features/transactions/domain/entities/expense_category.dart';
import 'package:spendly_app/features/transactions/presentation/mappers/expense_category_ui.dart';

/// 4-column grid of 8 category cards; selected = 2px colored border + tint
/// bg, per Add Transaction "Chi tiêu" tab layout.
class ExpenseCategoryGrid extends StatelessWidget {
  const ExpenseCategoryGrid(
      {required this.selected, required this.onSelected, super.key});

  final ExpenseCategory? selected;
  final ValueChanged<ExpenseCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      children: [
        for (final category in ExpenseCategory.values)
          _CategoryCard(
            category: category,
            isSelected: category == selected,
            onTap: () => onSelected(category),
          ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard(
      {required this.category, required this.isSelected, required this.onTap});

  final ExpenseCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Selected border/icon use the category's own hue (e.g. Y tế is sky
    // blue, Du lịch teal) — only the background tint is the shared Primary
    // tint, per design handoff `catStyle()`.
    final accentColor = isSelected ? category.ownColor : colors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryTint : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? category.ownColor : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 22, color: accentColor),
            const SizedBox(height: 6),
            Text(
              category.labelText(context),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10.5,
                    color: colors.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
