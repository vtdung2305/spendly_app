import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/date_picker_dialog_content.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/transaction_history/presentation/viewmodel/history_filter.dart';
import 'package:spendly_app/shared/components/dialogs/center_dialog.dart';

/// Expandable "Lọc theo" panel — date-range fields, quick filter chips, and
/// category chips, wired to a live [HistoryFilter].
class FilterChipPanel extends StatelessWidget {
  const FilterChipPanel({
    required this.filter,
    required this.categories,
    required this.hasActiveFilters,
    required this.onDateFromChanged,
    required this.onDateToChanged,
    required this.onQuickFilterChanged,
    required this.onCategoryChanged,
    required this.onClearFilters,
    super.key,
  });

  final HistoryFilter filter;
  final List<Category> categories;
  final bool hasActiveFilters;
  final ValueChanged<DateTime?> onDateFromChanged;
  final ValueChanged<DateTime?> onDateToChanged;
  final ValueChanged<HistoryQuickFilter> onQuickFilterChanged;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onClearFilters;

  Future<void> _pickDate(
    BuildContext context,
    ValueChanged<DateTime?> onChanged, {
    required DateTime? initialDate,
    DateTime? minSelectableDate,
  }) async {
    final picked = await CenterDialog.show<DateTime>(
      context,
      title: context.l10n.addTransactionDatePickerTitle,
      builder: (_) => DatePickerDialogContent(
        initialDate: initialDate ?? DateTime.now(),
        minSelectableDate: minSelectableDate,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.historyFilterDateRangeLabel,
            style:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: l10n.historyFilterFromLabel,
                  date: filter.dateFrom,
                  onTap: () => _pickDate(
                    context,
                    onDateFromChanged,
                    initialDate: filter.dateFrom,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _DateField(
                  label: l10n.historyFilterToLabel,
                  date: filter.dateTo,
                  onTap: () => _pickDate(
                    context,
                    onDateToChanged,
                    initialDate: filter.dateTo ?? filter.dateFrom,
                    minSelectableDate: filter.dateFrom,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.mdLg),
          Text(
            l10n.historyFilterQuickLabel,
            style:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _QuickFilterChip(
                label: l10n.historyFilterChipExpenseOnly,
                active: filter.quickFilter == HistoryQuickFilter.expenseOnly,
                onTap: () => onQuickFilterChanged(
                    filter.quickFilter == HistoryQuickFilter.expenseOnly
                        ? HistoryQuickFilter.none
                        : HistoryQuickFilter.expenseOnly),
              ),
              _QuickFilterChip(
                label: l10n.historyFilterChipIncomeOnly,
                active: filter.quickFilter == HistoryQuickFilter.incomeOnly,
                onTap: () => onQuickFilterChanged(
                    filter.quickFilter == HistoryQuickFilter.incomeOnly
                        ? HistoryQuickFilter.none
                        : HistoryQuickFilter.incomeOnly),
              ),
              _QuickFilterChip(
                label: l10n.historyFilterChipOver500k,
                active: filter.quickFilter == HistoryQuickFilter.over500k,
                onTap: () => onQuickFilterChanged(
                    filter.quickFilter == HistoryQuickFilter.over500k
                        ? HistoryQuickFilter.none
                        : HistoryQuickFilter.over500k),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.mdLg),
          Text(
            l10n.historyFilterCategoryLabel,
            style:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final category in categories)
                _CategoryChip(
                  category: category,
                  active: filter.categoryId == category.id,
                  onTap: () => onCategoryChanged(
                      filter.categoryId == category.id ? null : category.id),
                ),
            ],
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: AppSpacing.smMd),
            InkWell(
              onTap: onClearFilters,
              child: Text(
                l10n.historyClearFiltersButton,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.date, required this.onTap});

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(fontSize: 10.5, color: colors.textTertiary),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border.all(color: colors.border, width: 1.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              date == null ? '—' : DateFormat('dd/MM/yyyy').format(date!),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 12.5, color: colors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickFilterChip extends StatelessWidget {
  const _QuickFilterChip(
      {required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smMd, vertical: 7),
        decoration: BoxDecoration(
          color: active ? colors.primary : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : colors.textPrimary,
              ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(
      {required this.category, required this.active, required this.onTap});

  final Category category;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final categoryColor = categoryColorFromHex(category.colorHex);
    final color = active ? categoryColor : colors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
        decoration: BoxDecoration(
          color: active ? categoryColor.withValues(alpha: 0.1) : colors.surface,
          border: Border.all(color: active ? categoryColor : colors.border),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(categoryIconFor(category.iconName), size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
