import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/locale/locale_cubit.dart';
import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/theme_cubit.dart';
import 'package:spendly_app/shared/components/menu/menu_row.dart';
import 'package:spendly_app/shared/components/navigation/app_bottom_nav_bar.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';

/// Screen 13 — grouped into Chung/Dữ liệu/Hỗ trợ sections, each its own
/// card. "Giao diện"/"Ngôn ngữ" expand inline into a Sáng/Tối or Tiếng
/// Việt/English picker instead of navigating away. Reachable via the
/// bottom nav (Profile tab), no back arrow, per design handoff.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _expandedRow;

  void _toggle(String key) {
    setState(() => _expandedRow = _expandedRow == key ? null : key);
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
      case 4:
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeMode = context.watch<ThemeCubit>().state;
    final locale = context.watch<LocaleCubit>().state;
    final isDark = themeMode == ThemeMode.dark;
    final isEnglish = locale?.languageCode == 'en';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal),
          child: ListView(
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Text(context.l10n.settingsPageTitle, style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.mdLg),
              _SectionLabel(context.l10n.settingsSectionGeneral),
              _SectionCard(
                children: [
                  MenuRow(
                    icon: Icons.palette_rounded,
                    label: context.l10n.settingsThemeLabel,
                    value: isDark
                        ? context.l10n.settingsThemeValueDark
                        : context.l10n.settingsThemeValueLight,
                    onTap: () => _toggle('theme'),
                  ),
                  if (_expandedRow == 'theme')
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppSpacing.xxl, bottom: AppSpacing.xs),
                      child: Column(
                        children: [
                          _OptionRow(
                            label: context.l10n.settingsThemeValueLight,
                            selected: !isDark,
                            onTap: () {
                              if (isDark) context.read<ThemeCubit>().toggle();
                            },
                          ),
                          _OptionRow(
                            label: context.l10n.settingsThemeValueDark,
                            selected: isDark,
                            onTap: () {
                              if (!isDark) context.read<ThemeCubit>().toggle();
                            },
                          ),
                        ],
                      ),
                    ),
                  MenuRow(
                    icon: Icons.language_rounded,
                    label: context.l10n.settingsLanguageLabel,
                    value: isEnglish
                        ? context.l10n.settingsLanguageValueEnglish
                        : context.l10n.settingsLanguageValueVietnamese,
                    onTap: () => _toggle('language'),
                  ),
                  if (_expandedRow == 'language')
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppSpacing.xxl, bottom: AppSpacing.xs),
                      child: Column(
                        children: [
                          _OptionRow(
                            label: context.l10n.settingsLanguageValueVietnamese,
                            selected: !isEnglish,
                            onTap: () => context
                                .read<LocaleCubit>()
                                .setLocale(const Locale('vi')),
                          ),
                          _OptionRow(
                            label: context.l10n.settingsLanguageValueEnglish,
                            selected: isEnglish,
                            onTap: () => context
                                .read<LocaleCubit>()
                                .setLocale(const Locale('en')),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.cardGap),
              _SectionLabel(context.l10n.settingsSectionData),
              _SectionCard(
                children: [
                  MenuRow(
                      icon: Icons.cloud_upload_rounded,
                      label: context.l10n.settingsBackupDataLabel),
                  MenuRow(
                      icon: Icons.privacy_tip_rounded,
                      label: context.l10n.settingsPrivacyLabel),
                ],
              ),
              const SizedBox(height: AppSpacing.cardGap),
              _SectionLabel(context.l10n.settingsSectionSupport),
              _SectionCard(
                children: [
                  MenuRow(
                    icon: Icons.info_rounded,
                    label: context.l10n.settingsAboutAppLabel,
                    value: 'v1.0.0',
                  ),
                  MenuRow(
                      icon: Icons.feedback_rounded,
                      label: context.l10n.settingsFeedbackLabel),
                  MenuRow(
                      icon: Icons.description_rounded,
                      label: context.l10n.settingsTermsLabel),
                  MenuRow(
                    icon: Icons.widgets_rounded,
                    label: context.l10n.settingsFeedbackKitLabel,
                    onTap: () => context.push('/feedback-kit'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.mdLg),
            ],
          ),
        ),
      ),
      floatingActionButton:
          AppFab(onPressed: () => context.push('/add-transaction')),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AppBottomNavBar(
        onTabSelected: (index) => _handleTabSelected(context, index),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding:
          const EdgeInsets.only(bottom: AppSpacing.xs, left: AppSpacing.xxs),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: colors.textTertiary, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(children: children),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 18,
              color: selected ? colors.primary : colors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.smMd),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
