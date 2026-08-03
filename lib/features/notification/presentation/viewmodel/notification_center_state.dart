import 'package:spendly_app/features/notification/domain/entities/notification_item.dart';
import 'package:spendly_app/features/notification/domain/entities/reminder_settings.dart';

sealed class NotificationCenterState {
  const NotificationCenterState();
}

class NotificationCenterLoading extends NotificationCenterState {
  const NotificationCenterLoading();
}

class NotificationCenterLoaded extends NotificationCenterState {
  const NotificationCenterLoaded(this.notifications, this.settings);
  final List<NotificationItem> notifications;
  final ReminderSettings settings;
}

class NotificationCenterError extends NotificationCenterState {
  const NotificationCenterError(this.message);
  final String message;
}
