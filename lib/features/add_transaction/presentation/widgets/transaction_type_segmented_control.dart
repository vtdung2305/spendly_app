import 'package:flutter/material.dart';

import '../../../../core/theme/app_animation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../transactions/domain/entities/transaction.dart';

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
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: 'Chi tiêu',
              isActive: selected == TransactionType.expense,
              activeColor: colors.danger,
              onTap: () => onChanged(TransactionType.expense),
            ),
          ),
          Expanded(
            child: _Segment(
              label: 'Thu nhập',
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
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        decoration: BoxDecoration(
          color: isActive ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isActive ? activeColor : colors.textSecondary,
              ),
        ),
      ),
    );
  }
}
