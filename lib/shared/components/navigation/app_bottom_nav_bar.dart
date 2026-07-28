import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';

class AppNavTab {
  const AppNavTab({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// 5-tab bottom nav bar, per design handoff Global Chrome — height 72 +
/// safe area, 1px top border, icon 22px / label 10px. The FAB is a fully
/// separate floating element (see [AppFab]), not part of this bar.
/// [currentIndex] is 0-4 for Home/Calendar/Budget/Reports/Profile; pass
/// `null` when the current screen isn't one of the 5 tabs (e.g. Settings)
/// so no tab highlights.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.onTabSelected,
    super.key,
    this.currentIndex,
  });

  final int? currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final tabs = [
      AppNavTab(icon: Icons.home_rounded, label: context.l10n.navHomeTab),
      AppNavTab(
          icon: Icons.calendar_month_rounded,
          label: context.l10n.navCalendarTab),
      AppNavTab(
          icon: Icons.account_balance_wallet_rounded,
          label: context.l10n.navBudgetTab),
      AppNavTab(
          icon: Icons.bar_chart_rounded, label: context.l10n.navReportsTab),
      AppNavTab(icon: Icons.person_rounded, label: context.l10n.navProfileTab),
    ];

    return Container(
      height: 80,
      padding: EdgeInsets.only(
          top: 5, bottom: bottomSafeArea > 14 ? bottomSafeArea : 14),
      decoration: BoxDecoration(
        color: colors.navBg,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < tabs.length; i++)
            _NavItem(
              tab: tabs[i],
              selected: currentIndex == i,
              onTap: () => onTabSelected(i),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.tab, required this.selected, required this.onTap});

  final AppNavTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.primary : colors.textTertiary;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tab.icon, size: 20, color: color),
          const SizedBox(height: 2),
          Text(
            tab.label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
