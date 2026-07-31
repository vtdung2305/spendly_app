import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/locale/locale_cubit.dart';
import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/theme_cubit.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/shared/components/navigation/app_bottom_nav_bar.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';
import 'package:spendly_app/shared/components/menu/menu_row.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    final headerHeight = MediaQuery.paddingOf(context).top + 56;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                top: headerHeight,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const SizedBox(height: AppSpacing.mdLg),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(color: colors.border),
                            boxShadow: AppShadow.card,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: colors.primary,
                                    shape: BoxShape.circle),
                                child: Text(
                                  user?.initials ?? '?',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user?.name ?? '',
                                        style: textTheme.titleSmall),
                                    const SizedBox(height: 2),
                                    Text(
                                      user?.email ?? '',
                                      style: textTheme.bodySmall?.copyWith(
                                          color: colors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: colors.surfaceAlt,
                                borderRadius: BorderRadius.circular(11),
                                child: InkWell(
                                  onTap: () => context.push('/profile/edit'),
                                  borderRadius: BorderRadius.circular(11),
                                  child: SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: Icon(Icons.edit_rounded,
                                        size: 18, color: colors.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.cardGap),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(color: colors.border),
                            boxShadow: AppShadow.card,
                          ),
                          child: Column(
                            children: [
                              BlocBuilder<ThemeCubit, ThemeMode>(
                                builder: (context, mode) {
                                  return MenuRow(
                                    icon: Icons.dark_mode_rounded,
                                    label: context.l10n.profileDarkModeLabel,
                                    onTap: () =>
                                        context.read<ThemeCubit>().toggle(),
                                    trailing: _DarkModeSwitch(
                                      isDark: mode == ThemeMode.dark,
                                      onTap: () =>
                                          context.read<ThemeCubit>().toggle(),
                                    ),
                                  );
                                },
                              ),
                              MenuRow(
                                icon: Icons.notifications_rounded,
                                label: context.l10n.profileNotificationsLabel,
                                value: context.l10n.profileNotificationsValueOn,
                              ),
                              MenuRow(
                                icon: Icons.attach_money_rounded,
                                label: context.l10n.profileCurrencyLabel,
                                value: context.l10n.profileCurrencyValueVnd,
                              ),
                              Builder(
                                builder: (context) {
                                  final isEnglish = context
                                          .watch<LocaleCubit>()
                                          .state
                                          ?.languageCode ==
                                      'en';
                                  return MenuRow(
                                    icon: Icons.language_rounded,
                                    label: context.l10n.profileLanguageLabel,
                                    value: isEnglish
                                        ? context
                                            .l10n.profileLanguageValueEnglish
                                        : context.l10n
                                            .profileLanguageValueVietnamese,
                                  );
                                },
                              ),
                              MenuRow(
                                icon: Icons.account_balance_wallet_rounded,
                                label: context.l10n.profileBudgetLabel,
                                onTap: () => context.push('/budget'),
                              ),
                              MenuRow(
                                icon: Icons.savings_rounded,
                                label:
                                    context.l10n.profileIncomeManagementLabel,
                                onTap: () => context.push('/income'),
                              ),
                              MenuRow(
                                icon: Icons.category_rounded,
                                label:
                                    context.l10n.profileCategoryManagementLabel,
                                onTap: () => context.push('/categories'),
                              ),
                              MenuRow(
                                icon: Icons.settings_rounded,
                                label: context.l10n.profileSettingsLabel,
                                onTap: () => context.push('/settings'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.mdLg),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              await context.read<AuthCubit>().signOut();
                              if (context.mounted) context.go('/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.dangerTint,
                              foregroundColor: colors.danger,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.lg)),
                            ),
                            child: Text(context.l10n.profileLogoutButton,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppHeader(
                  title: context.l10n.profilePageTitle, titleFontSize: 20),
            ],
          ),
        ),
        floatingActionButton:
            AppFab(onPressed: () => context.push('/add-transaction')),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 4,
          onTabSelected: (index) => _handleTabSelected(context, index),
        ),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/calendar');
      case 2:
        context.go('/budget');
      case 3:
        context.go('/reports');
    }
  }
}

/// 40x24 pill + 18x18 white knob, per design handoff Profile screen
/// (`darkTrack`/`darkKnobLeft2`) — off = slate #CBD5E1, on = theme primary
/// (#818CF8 in dark mode).
class _DarkModeSwitch extends StatelessWidget {
  const _DarkModeSwitch({required this.isDark, required this.onTap});

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 24,
        width: 40,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isDark ? colors.primary : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            height: 18,
            width: 18,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
