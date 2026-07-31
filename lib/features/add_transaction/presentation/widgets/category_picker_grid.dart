import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/shared/components/borders/dashed_rrect_border.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';

/// [grid]: 4-col square cards (Add Transaction's Chi tiêu tab, Add/Edit
/// Budget's category picker). [list]: 2-col row cards with a checkmark
/// (Add Transaction's Thu nhập tab) — mirrors the design's distinct layouts
/// for expense vs. income category pickers.
enum CategoryPickerStyle { grid, list }

/// Replaces the old fixed-enum `ExpenseCategoryGrid`/`IncomeSourceList` —
/// one widget driven by a dynamic [categories] list from either data source.
/// When [onAddCategory] is given, a trailing dashed "Thêm" tile opens
/// Category Management's create screen (Add Budget's grid has no such tile,
/// per design — leave it null there).
class CategoryPickerGrid extends StatelessWidget {
  const CategoryPickerGrid({
    required this.categories,
    required this.selected,
    required this.onSelected,
    super.key,
    this.style = CategoryPickerStyle.grid,
    this.onAddCategory,
  });

  final List<Category> categories;
  final Category? selected;
  final ValueChanged<Category> onSelected;
  final CategoryPickerStyle style;
  final VoidCallback? onAddCategory;

  @override
  Widget build(BuildContext context) {
    return style == CategoryPickerStyle.grid ? _buildGrid() : _buildList();
  }

  Widget _buildGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      children: [
        for (final category in categories)
          _GridCard(
            category: category,
            isSelected: category.id == selected?.id,
            onTap: () => onSelected(category),
          ),
        if (onAddCategory != null) _AddCategoryGridCard(onTap: onAddCategory!),
      ],
    );
  }

  Widget _buildList() {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3.1,
      children: [
        for (final category in categories)
          _ListCard(
            category: category,
            isSelected: category.id == selected?.id,
            onTap: () => onSelected(category),
          ),
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard(
      {required this.category, required this.isSelected, required this.onTap});

  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ownColor = categoryColorFromHex(category.colorHex);
    final accentColor = isSelected ? ownColor : colors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryTint : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? ownColor : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(categoryIconFor(category.iconName),
                size: 22, color: accentColor),
            const SizedBox(height: 6),
            Text(
              category.label,
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

class _ListCard extends StatelessWidget {
  const _ListCard(
      {required this.category, required this.isSelected, required this.onTap});

  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryTint : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(categoryIconFor(category.iconName),
                size: 20,
                color: isSelected ? colors.primary : colors.textSecondary),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                category.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 17,
              color: isSelected ? colors.primary : colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCategoryGridCard extends StatelessWidget {
  const _AddCategoryGridCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: DashedRRectBorder(
        color: colors.primary,
        radius: AppRadius.lg,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          decoration: BoxDecoration(
            color: colors.primaryTint,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 22, color: colors.primary),
              const SizedBox(height: 6),
              Text(
                context.l10n.addTransactionAddCategoryTile,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10.5,
                      color: colors.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
