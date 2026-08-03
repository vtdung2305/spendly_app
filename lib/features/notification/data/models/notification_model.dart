import 'package:spendly_app/features/notification/domain/entities/notification_item.dart';

/// DTO for the custom backend's `/api/v1/notifications` row shape.
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.icon,
    required this.tone,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromBackendJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: switch (json['type'] as String) {
        'BUDGET_ALERT' => NotificationType.budgetAlert,
        'RECURRING_GENERATED' => NotificationType.recurringGenerated,
        _ => NotificationType.dailyReminder,
      },
      title: json['title'] as String,
      body: json['body'] as String,
      icon: json['icon'] as String,
      tone: json['tone'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final String icon;
  final String tone;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem toEntity() => NotificationItem(
        id: id,
        type: type,
        title: title,
        body: body,
        icon: icon,
        tone: tone,
        isRead: isRead,
        createdAt: createdAt,
      );
}
