import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/features/transactions/domain/entities/income_source.dart';
import 'package:spendly_app/features/transactions/presentation/mappers/income_source_ui.dart';

/// 2-column grid of income-source cards (icon + label + radio checkmark);
/// selected = 2px Primary border + tint, per Add Transaction "Thu nhập" tab.
class IncomeSourceList extends StatelessWidget {
  const IncomeSourceList(
      {required this.selected, required this.onSelected, super.key});

  final IncomeSource? selected;
  final ValueChanged<IncomeSource> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3.1,
      children: [
        for (final source in IncomeSource.values)
          _SourceCard(
            source: source,
            isSelected: source == selected,
            onTap: () => onSelected(source),
          ),
      ],
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard(
      {required this.source, required this.isSelected, required this.onTap});

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
            Icon(source.icon,
                size: 20,
                color: isSelected ? colors.primary : colors.textSecondary),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                source.labelText(context),
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
