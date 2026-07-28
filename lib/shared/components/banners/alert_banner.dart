import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

enum AlertBannerVariant { success, error, warning, info }

/// Tinted-background alert — icon + title + description + dismiss, no
/// colored left border (per Messages & Feedback Kit catalog — a plain
/// border-left accent reads as a generic AI-generated card).
class AlertBanner extends StatelessWidget {
  const AlertBanner({
    required this.variant,
    required this.title,
    required this.description,
    this.onDismiss,
    super.key,
  });

  final AlertBannerVariant variant;
  final String title;
  final String description;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, iconColor, bgColor) = switch (variant) {
      AlertBannerVariant.success => (
          Icons.check_circle_rounded,
          colors.success,
          colors.successTint
        ),
      AlertBannerVariant.error => (
          Icons.error_rounded,
          colors.danger,
          colors.dangerTint
        ),
      AlertBannerVariant.warning => (
          Icons.warning_rounded,
          colors.warning,
          colors.warningTint
        ),
      AlertBannerVariant.info => (
          Icons.info_rounded,
          colors.primary,
          colors.primaryTint
        ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: iconColor),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          InkWell(
            onTap: onDismiss,
            child:
                Icon(Icons.close_rounded, size: 17, color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}
