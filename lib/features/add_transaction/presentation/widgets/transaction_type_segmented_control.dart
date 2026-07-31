import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// "Chi tiêu / Thu nhập" segmented control — active segment is
/// white/Surface with a colored label (danger for expense, success for
/// income), per Add Transaction layout.
class TransactionTypeSegmentedControl extends StatelessWidget {
  const TransactionTypeSegmentedControl({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: context.l10n.addTransactionTypeExpense,
              isActive: selected == TransactionType.expense,
              activeColor: colors.danger,
              onTap: () => onChanged(TransactionType.expense),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _Segment(
              label: context.l10n.addTransactionTypeIncome,
              isActive: selected == TransactionType.income,
              activeColor: colors.success,
              onTap: () => onChanged(TransactionType.income),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isActive ? activeColor : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
