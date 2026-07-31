import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/features/reports/presentation/mappers/report_period_ui.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';

/// "Tuần / Tháng / Năm" segmented control, per Reports layout.
class ReportPeriodTabs extends StatelessWidget {
  const ReportPeriodTabs(
      {required this.selected, required this.onChanged, super.key});

  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          for (final period in ReportPeriod.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(period),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: period == selected
                        ? colors.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm - 1),
                  ),
                  child: Text(
                    period.labelText(context),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: period == selected
                              ? colors.primary
                              : colors.textSecondary,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
