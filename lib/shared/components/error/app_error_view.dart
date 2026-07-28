import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

/// Error state: message + retry button.
class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colors.danger),
            const SizedBox(height: AppSpacing.mdLg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.mdLg),
            OutlinedButton(
                onPressed: onRetry, child: Text(context.l10n.commonRetry)),
          ],
        ),
      ),
    );
  }
}
