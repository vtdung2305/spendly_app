import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../transactions/domain/entities/income_source.dart';
import '../../../transactions/presentation/mappers/income_source_ui.dart';

/// Vertical list of 4 rows (icon + label + radio checkmark); selected = 2px
/// Primary border + tint, per Add Transaction "Thu nhập" tab layout.
class IncomeSourceList extends StatelessWidget {
  const IncomeSourceList({required this.selected, required this.onSelected, super.key});

  final IncomeSource? selected;
  final ValueChanged<IncomeSource> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final source in IncomeSource.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SourceRow(
              source: source,
              isSelected: source == selected,
              onTap: () => onSelected(source),
            ),
          ),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source, required this.isSelected, required this.onTap});

  final IncomeSource source;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
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
            Icon(source.icon, size: 20, color: isSelected ? colors.primary : colors.textSecondary),
            const SizedBox(width: 12),
            Expanded(child: Text(source.label, style: Theme.of(context).textTheme.bodyLarge)),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 20,
              color: isSelected ? colors.primary : colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
