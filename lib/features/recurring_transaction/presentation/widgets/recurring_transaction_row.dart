import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// One row on the Recurring Transaction list (10b) — icon/amount colored by
/// [RecurringTransaction.type] (not the category's own color), per design
/// handoff; a status badge distinguishes active from paused rows.
class RecurringTransactionRow extends StatelessWidget {
  const RecurringTransactionRow(
      {required this.recurring, required this.onTap, super.key});

  final RecurringTransaction recurring;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isIncome = recurring.type == TransactionType.income;
    final tintColor = isIncome ? colors.success : colors.primary;
    final amountColor = isIncome ? colors.success : colors.danger;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.mdLg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colors.border),
          boxShadow: AppShadow.card,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isIncome ? colors.successTint : colors.primaryTint,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(categoryIconFor(recurring.category.iconName),
                  size: 20, color: tintColor),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recurring.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.recurringTransactionMonthlyOnDay(
                      recurring.category.label,
                      recurring.dayOfMonth.toString(),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${CurrencyFormatter.format(recurring.amount)}',
                  style: AppTypography.mono(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: amountColor),
                ),
                const SizedBox(height: 3),
                Text(
                  recurring.isActive
                      ? context.l10n.recurringTransactionStatusActive
                      : context.l10n.recurringTransactionStatusPaused,
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: recurring.isActive
                          ? colors.success
                          : colors.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
