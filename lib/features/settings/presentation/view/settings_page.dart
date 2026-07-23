import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadow.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../shared/components/buttons/bordered_icon_button.dart';
import '../../../../shared/components/menu/menu_row.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final themeMode = context.watch<ThemeCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Row(
                children: [
                  BorderedIconButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('Cài đặt', style: textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.mdLg),
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
                    MenuRow(
                      icon: Icons.palette_rounded,
                      label: 'Giao diện',
                      value: themeMode == ThemeMode.dark ? 'Tối' : 'Sáng',
                    ),
                    const MenuRow(icon: Icons.language_rounded, label: 'Ngôn ngữ', value: 'Tiếng Việt'),
                    const MenuRow(icon: Icons.cloud_upload_rounded, label: 'Sao lưu dữ liệu'),
                    const MenuRow(icon: Icons.privacy_tip_rounded, label: 'Quyền riêng tư'),
                    const MenuRow(icon: Icons.info_rounded, label: 'Về ứng dụng', value: 'v1.0.0'),
                    const MenuRow(icon: Icons.feedback_rounded, label: 'Góp ý'),
                    const MenuRow(icon: Icons.description_rounded, label: 'Điều khoản'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
