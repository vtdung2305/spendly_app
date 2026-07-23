import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Icon + label + optional trailing value + chevron — the settings-style
/// row shared by Profile and Settings menu cards.
class MenuRow extends StatelessWidget {
  const MenuRow({
    required this.icon,
    required this.label,
    super.key,
    this.value,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  /// Overrides the default chevron (e.g. a Switch for Dark mode).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.smMd),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.textSecondary),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            ),
            if (trailing != null)
              trailing!
            else ...[
              if (value != null && value!.isNotEmpty)
                Text(
                  value!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.textTertiary),
                ),
              const SizedBox(width: AppSpacing.xxs),
              Icon(Icons.chevron_right_rounded, size: 18, color: colors.textTertiary),
            ],
          ],
        ),
      ),
    );
  }
}
