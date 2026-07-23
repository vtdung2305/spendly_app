import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadow.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../shared/components/navigation/app_bottom_nav_bar.dart';
import '../../../../shared/components/menu/menu_row.dart';
import '../../../authentication/presentation/viewmodel/auth_cubit.dart';
import '../../../authentication/presentation/viewmodel/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: ListView(
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Text('Hồ sơ', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
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
                      decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                      child: Text(
                        user?.initials ?? '?',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? '', style: textTheme.titleSmall),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                        ),
                      ],
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
                          label: 'Dark mode',
                          trailing: Switch(
                            value: mode == ThemeMode.dark,
                            onChanged: (_) => context.read<ThemeCubit>().toggle(),
                          ),
                        );
                      },
                    ),
                    const MenuRow(icon: Icons.notifications_rounded, label: 'Thông báo', value: 'Bật'),
                    const MenuRow(icon: Icons.attach_money_rounded, label: 'Đơn vị tiền tệ', value: 'VNĐ'),
                    const MenuRow(icon: Icons.language_rounded, label: 'Ngôn ngữ', value: 'Tiếng Việt'),
                    MenuRow(
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Ngân sách',
                      onTap: () => context.push('/budget'),
                    ),
                    MenuRow(
                      icon: Icons.savings_rounded,
                      label: 'Quản lý thu nhập',
                      onTap: () => context.push('/income'),
                    ),
                    MenuRow(
                      icon: Icons.settings_rounded,
                      label: 'Cài đặt',
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                  ),
                  child: const Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTabSelected: (index) => _handleTabSelected(context, index),
        onFabPressed: () => Navigator.of(context).pushNamed('/add-transaction'),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/dashboard');
      case 1:
        Navigator.of(context).pushReplacementNamed('/calendar');
      case 2:
        Navigator.of(context).pushReplacementNamed('/reports');
    }
  }
}
