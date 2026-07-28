import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

/// Confirmation dialog content — icon tile + title + description + Cancel/
/// Confirm buttons, per Messages & Feedback Kit catalog (screen 14). Used
/// both as the real modal (via [show]) and as a static preview on that
/// catalog screen, so both stay pixel-identical by construction.
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.icon,
    required this.title,
    required this.description,
    required this.cancelLabel,
    required this.confirmLabel,
    this.onCancel,
    this.onConfirm,
    this.destructive = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  /// Whether the confirm button uses danger styling (delete-style actions)
  /// vs primary styling.
  final bool destructive;

  /// Shows the dialog and resolves `true` if the user confirmed, `false`
  /// otherwise (cancel, scrim tap, back gesture).
  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String cancelLabel,
    required String confirmLabel,
    bool destructive = true,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AppConfirmDialog(
          icon: icon,
          title: title,
          description: description,
          cancelLabel: cancelLabel,
          confirmLabel: confirmLabel,
          destructive: destructive,
          onCancel: () => Navigator.of(dialogContext).pop(false),
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        ),
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final confirmColor = destructive ? colors.danger : colors.primary;
    final iconTint = destructive ? colors.dangerTint : colors.primaryTint;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: iconTint, shape: BoxShape.circle),
            child: Icon(icon, size: 24, color: confirmColor),
          ),
          const SizedBox(height: AppSpacing.smMd),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontSize: 14.5),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12, color: colors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _DialogButton(
                  label: cancelLabel,
                  background: colors.surfaceAlt,
                  foreground: colors.textPrimary,
                  onTap: onCancel,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _DialogButton(
                  label: confirmLabel,
                  background: confirmColor,
                  foreground: Colors.white,
                  onTap: onConfirm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.sm)),
        child: Text(label,
            style: TextStyle(
                color: foreground,
                fontSize: 12.5,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}
