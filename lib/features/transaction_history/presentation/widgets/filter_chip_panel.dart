import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadow.dart';
import '../../../../core/theme/app_spacing.dart';

const _kFilterChips = ['Tuần này', 'Ăn uống', 'Trên 500K', 'Chỉ chi tiêu'];

/// Expandable "Lọc theo" panel — chips are decorative per design handoff
/// (Date/Category/Amount/Type filters, no live re-filtering wired in mock).
class FilterChipPanel extends StatelessWidget {
  const FilterChipPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
            'Lọc theo',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final label in _kFilterChips)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd, vertical: 7),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 11.5, color: colors.textPrimary),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
