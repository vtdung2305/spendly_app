import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';

enum HistoryView { list, chart }

/// "Danh sách" / "Biểu đồ" segmented control, per History layout — same
/// visual pattern as Reports' period tabs.
class HistoryViewTabs extends StatelessWidget {
  const HistoryViewTabs(
      {required this.selected, required this.onChanged, super.key});

  final HistoryView selected;
  final ValueChanged<HistoryView> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          for (final view in HistoryView.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(view),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: view == selected ? colors.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm - 1),
                  ),
                  child: Text(
                    view == HistoryView.list
                        ? l10n.historyTabList
                        : l10n.historyTabChart,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: view == selected
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
