import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/features/notification/domain/entities/notification_item.dart';
import 'package:spendly_app/features/notification/presentation/mappers/notification_icon_ui.dart';

/// One row in the Notification Center's "Gần đây" list — unread rows get a
/// border + blue dot; read rows are dimmed, per design handoff.
class NotificationRow extends StatelessWidget {
  const NotificationRow({required this.notification, super.key});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (iconColor, iconBg) =
        notificationToneColors(colors, notification.tone);

    return Opacity(
      opacity: notification.isRead ? 0.72 : 1,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.mdLg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: notification.isRead
              ? null
              : Border.all(color: colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              alignment: Alignment.center,
              child: Icon(notificationIconFor(notification.icon),
                  size: 18, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _relativeTime(context, notification.createdAt),
                        style:
                            TextStyle(fontSize: 11, color: colors.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.body,
                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _relativeTime(BuildContext context, DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return context.l10n.notificationTimeJustNow;
    if (diff.inHours < 1) {
      return context.l10n.notificationTimeMinutesAgo(diff.inMinutes.toString());
    }
    if (diff.inHours < 24) {
      return context.l10n.notificationTimeHoursAgo(diff.inHours.toString());
    }
    if (diff.inDays == 1) return context.l10n.notificationTimeYesterday;
    return context.l10n.notificationTimeDaysAgo(diff.inDays.toString());
  }
}
