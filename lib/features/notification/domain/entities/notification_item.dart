/// Mirrors the backend's `NotificationType` enum — all three are
/// server-generated (no manual-create API), per the Notification Center
/// (screen 10d).
enum NotificationType { budgetAlert, dailyReminder, recurringGenerated }

/// One row in `GET /notifications` — `icon`/`tone` are backend-chosen
/// Material icon name / semantic color key, kept as raw strings here since
/// mapping to Flutter [IconData]/[Color] is a presentation concern.
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.icon,
    required this.tone,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final String icon;
  final String tone;
  final bool isRead;
  final DateTime createdAt;
}
