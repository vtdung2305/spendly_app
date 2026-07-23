import 'package:flutter/material.dart';

import '../../../core/theme/app_animation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Bottom-anchored success confirmation, auto-dismiss after 2.5s — per
/// design handoff Global Chrome ("Đã lưu khoản chi" / "Đã lưu khoản thu").
abstract class AppSnackbar {
  static void showSuccess(BuildContext context, String message) {
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
          margin: const EdgeInsets.only(bottom: 100, left: 40, right: 40),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: colors.success, size: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
