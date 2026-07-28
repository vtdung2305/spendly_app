import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/locale/locale_cubit.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_state.dart';

/// Screen 1b — first-launch language picker shown right after Splash, before
/// Login/Dashboard. Deliberately bilingual/hardcoded (not run through
/// [AppLocalizations]) since no language has been chosen yet.
class LanguageSelectPage extends StatefulWidget {
  const LanguageSelectPage({super.key});

  @override
  State<LanguageSelectPage> createState() => _LanguageSelectPageState();
}

class _LanguageSelectPageState extends State<LanguageSelectPage> {
  String _selectedCode = 'vi';

  Future<void> _continue() async {
    await context.read<LocaleCubit>().setLocale(Locale(_selectedCode));
    if (!mounted) return;
    final authState = context.read<AuthCubit>().state;
    context.go(authState is AuthAuthenticated ? '/dashboard' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.splashEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.authHorizontal),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxl2),
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(Icons.language_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: AppSpacing.lgXl),
                const Text(
                  'Chọn ngôn ngữ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select your preferred language',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.75)),
                ),
                const SizedBox(height: AppSpacing.xxl2),
                Row(
                  children: [
                    Expanded(
                      child: _LanguageCard(
                        code: 'VI',
                        nativeName: 'Tiếng Việt',
                        subtitle: 'Vietnamese',
                        isSelected: _selectedCode == 'vi',
                        onTap: () => setState(() => _selectedCode = 'vi'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.smMd),
                    Expanded(
                      child: _LanguageCard(
                        code: 'EN',
                        nativeName: 'English',
                        subtitle: 'Tiếng Anh',
                        isSelected: _selectedCode == 'en',
                        onTap: () => setState(() => _selectedCode = 'en'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl2),
                AppButton(label: 'Tiếp tục', onPressed: _continue),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lgXl),
                  child: Text(
                    'Bạn có thể thay đổi ngôn ngữ sau trong Cài đặt',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.65)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.code,
    required this.nativeName,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String nativeName;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.mdLg),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isSelected ? 0.22 : 0.12),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Colors.white, width: isSelected ? 2 : 1),
          boxShadow: isSelected ? AppShadow.card : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    code,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppSpacing.smMd),
                Text(
                  nativeName,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                ),
              ],
            ),
            if (isSelected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
