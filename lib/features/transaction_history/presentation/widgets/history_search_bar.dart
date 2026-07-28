import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

/// Search field (Surface Alt, search icon) + adjacent filter icon-button
/// (turns Primary-filled when the filter panel is open), per History layout.
class HistorySearchBar extends StatelessWidget {
  const HistorySearchBar({
    required this.onChanged,
    required this.filterOpen,
    required this.onToggleFilter,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final bool filterOpen;
  final VoidCallback onToggleFilter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd),
            height: 44,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded,
                    size: 18, color: colors.textTertiary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: context.l10n.historySearchHint,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 13, color: colors.textTertiary),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        InkWell(
          onTap: onToggleFilter,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: filterOpen ? colors.primary : colors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 18,
              color: filterOpen ? Colors.white : colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
