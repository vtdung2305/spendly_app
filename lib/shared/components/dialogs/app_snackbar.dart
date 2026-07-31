import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_animation.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';

/// Bottom-anchored success confirmation, auto-dismiss after 2.5s — per
/// design handoff Global Chrome ("Đã lưu khoản chi" / "Đã lưu khoản thu").
/// Error/Warning/Info variants share the same dark-pill shape (per Messages
/// & Feedback Kit catalog), swapping only the leading icon/color.
abstract class AppSnackbar {
  static void showSuccess(BuildContext context, String message) =>
      _show(context, message,
          icon: Icons.check_circle_rounded, iconColor: context.colors.success);

  static void showError(BuildContext context, String message) =>
      _show(context, message,
          icon: Icons.error_rounded, iconColor: context.colors.danger);

  static void showWarning(BuildContext context, String message) =>
      _show(context, message,
          icon: Icons.warning_rounded, iconColor: context.colors.warning);

  static void showInfo(BuildContext context, String message) =>
      _show(context, message,
          icon: Icons.info_rounded, iconColor: context.colors.primary);

  static void _show(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color iconColor,
  }) {
    final colors = context.colors;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: AppAnimation.snackbarVisible,
          behavior: SnackBarBehavior.floating,
          backgroundColor: colors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
