import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/shared/components/charts/donut_chart.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';

class _CategorySlice {
  const _CategorySlice(
      {required this.category, required this.amount, required this.percent});
  final Category category;
  final double amount;
  final double percent;
}

/// "Biểu đồ" tab of Transaction History — income/expense/net stat row,
/// category donut breakdown, and a bar strip of the most recent transactions
/// within the currently applied filters.
class HistoryChartView extends StatelessWidget {
  const HistoryChartView({required this.transactions, super.key});

  final List<Transaction> transactions;

  static const _recentCount = 10;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    if (transactions.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: constraints.maxWidth,
          child: AppEmptyView(
            icon: Icons.bar_chart_rounded,
            message: l10n.historyChartEmptyMessage,
          ),
        ),
      );
    }

    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final categoryTotals = <String, double>{};
    final categoryById = <String, Category>{};
    for (final t in transactions) {
      if (t.type != TransactionType.expense || t.category == null) continue;
      final id = t.category!.id;
      categoryTotals[id] = (categoryTotals[id] ?? 0) + t.amount;
      categoryById[id] = t.category!;
    }
    final slices = categoryTotals.entries
        .map((e) => _CategorySlice(
              category: categoryById[e.key]!,
              amount: e.value,
              percent: totalExpense == 0 ? 0 : (e.value / totalExpense) * 100,
            ))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final recent = transactions.take(_recentCount).toList().reversed.toList();
    final maxAmount =
        recent.fold<double>(1, (max, t) => t.amount > max ? t.amount : max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colors.border),
            boxShadow: AppShadow.card,
          ),
          child: Column(
            children: [
              _StatRow(
                label: l10n.historyChartIncomeLabel,
                value: CurrencyFormatter.format(totalIncome),
                valueColor: colors.success,
              ),
              const SizedBox(height: AppSpacing.xs),
              _StatRow(
                label: l10n.historyChartExpenseLabel,
                value: CurrencyFormatter.format(totalExpense),
                valueColor: colors.danger,
              ),
              const SizedBox(height: AppSpacing.xs),
              _StatRow(
                label: l10n.historyChartNetLabel,
                value: CurrencyFormatter.format(totalIncome - totalExpense),
                valueColor: colors.textPrimary,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        if (slices.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: colors.border),
              boxShadow: AppShadow.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.historyChartCategoryCardTitle,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DonutChart(
                      size: 104,
                      strokeWidth: 18,
                      slices: [
                        for (final s in slices)
                          DonutSlice(
                              color: categoryColorFromHex(s.category.colorHex),
                              percent: s.percent),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.lgXl),
                    Expanded(
                      child: Column(
                        children: [
                          for (final s in slices)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                        color: categoryColorFromHex(
                                            s.category.colorHex),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Expanded(
                                    child: Text(
                                      s.category.label,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: colors.textSecondary,
                                              fontSize: 12),
                                    ),
                                  ),
                                  Text(
                                    '${s.percent.round()}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: colors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11.5,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.cardGap),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
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
                l10n.historyChartRecentCardTitle(transactions.length.toString()),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.mdLg),
              SizedBox(
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final t in recent)
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 2.5),
                          child: FractionallySizedBox(
                            heightFactor:
                                (t.amount / maxAmount).clamp(0.08, 1.0),
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: t.type == TransactionType.income
                                    ? colors.success
                                    : colors.danger,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(2),
                                  bottomRight: Radius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(
      {required this.label, required this.value, required this.valueColor});

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.mono(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: colors.textTertiary,
            letterSpacing: 0.06 * 10.5,
          ),
        ),
        Text(
          value,
          style: AppTypography.mono(
              fontSize: 14, fontWeight: FontWeight.w800, color: valueColor),
        ),
      ],
    );
  }
}
