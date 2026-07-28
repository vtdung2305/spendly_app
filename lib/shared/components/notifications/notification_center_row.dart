import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

/// Icon + title + timestamp + unread dot — Notification Center list row,
/// per Messages & Feedback Kit catalog.
class NotificationCenterRow extends StatelessWidget {
  const NotificationCenterRow({
    required this.icon,
    required this.title,
    required this.timestamp,
    this.unread = false,
    this.showTopDivider = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String timestamp;
  final bool unread;

  /// Set on every row after the first, per design (border between rows,
  /// none above the first or below the last).
  final bool showTopDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        border: showTopDivider
            ? Border(top: BorderSide(color: colors.border))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: colors.textSecondary),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  timestamp,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          if (unread)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color: colors.primary, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}
