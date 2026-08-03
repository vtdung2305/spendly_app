import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/notification/domain/entities/notification_item.dart';
import 'package:spendly_app/features/notification/domain/entities/reminder_settings.dart';

abstract class INotificationRepository {
  Future<Either<Failure, List<NotificationItem>>> getNotifications();

  Future<Either<Failure, Unit>> markAllAsRead();

  Future<Either<Failure, ReminderSettings>> getReminderSettings();

  Future<Either<Failure, ReminderSettings>> updateReminderSettings(
      ReminderSettings settings);
}
