import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadow.dart';

class AppNavTab {
  const AppNavTab({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

const _kNavTabs = [
  AppNavTab(icon: Icons.home_rounded, label: 'Trang chủ'),
  AppNavTab(icon: Icons.calendar_month_rounded, label: 'Lịch'),
  AppNavTab(icon: Icons.bar_chart_rounded, label: 'Báo cáo'),
  AppNavTab(icon: Icons.person_rounded, label: 'Cá nhân'),
];

/// 5-slot bottom nav (4 tabs + center FAB), per design handoff Global Chrome:
/// height ~88px + safe area, 1px top border, center FAB raised 26px with
/// Primary shadow. [currentIndex] refers to the 4 real tabs (0-3); the FAB
/// has no "active" state.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.onFabPressed,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onFabPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 88 + bottomSafeArea,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            padding: EdgeInsets.only(bottom: bottomSafeArea),
            child: Row(
              children: [
                _NavItem(
                  tab: _kNavTabs[0],
                  selected: currentIndex == 0,
                  onTap: () => onTabSelected(0),
                ),
                _NavItem(
                  tab: _kNavTabs[1],
                  selected: currentIndex == 1,
                  onTap: () => onTabSelected(1),
                ),
                const SizedBox(width: 64),
                _NavItem(
                  tab: _kNavTabs[2],
                  selected: currentIndex == 2,
                  onTap: () => onTabSelected(2),
                ),
                _NavItem(
                  tab: _kNavTabs[3],
                  selected: currentIndex == 3,
                  onTap: () => onTabSelected(3),
                ),
              ],
            ),
          ),
          Positioned(
            top: -26,
            child: GestureDetector(
              onTap: onFabPressed,
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  boxShadow: AppShadow.fab,
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.tab, required this.selected, required this.onTap});

  final AppNavTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.primary : colors.textTertiary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tab.icon, size: 24, color: color),
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
        ),
      ),
    );
  }
}
