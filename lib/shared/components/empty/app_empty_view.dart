import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Centered empty-state: icon + message + optional CTA.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.icon,
    required this.message,
    super.key,
    this.ctaLabel,
    this.onCtaPressed,
  });

  final IconData icon;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: colors.textTertiary),
            const SizedBox(height: AppSpacing.mdLg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: colors.textSecondary),
            ),
            if (ctaLabel != null) ...[
              const SizedBox(height: AppSpacing.mdLg),
              TextButton(
                onPressed: onCtaPressed,
                child: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
