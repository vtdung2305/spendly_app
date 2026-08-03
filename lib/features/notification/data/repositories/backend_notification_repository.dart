import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/core/network/backend_error_mapper.dart';
import 'package:spendly_app/features/notification/data/datasources/backend_notification_remote_datasource.dart';
import 'package:spendly_app/features/notification/data/models/reminder_settings_model.dart';
import 'package:spendly_app/features/notification/domain/entities/notification_item.dart';
import 'package:spendly_app/features/notification/domain/entities/reminder_settings.dart';
import 'package:spendly_app/features/notification/domain/repositories/i_notification_repository.dart';

class BackendNotificationRepository implements INotificationRepository {
  const BackendNotificationRepository(this._dataSource);

  final BackendNotificationRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<NotificationItem>>> getNotifications() async {
    try {
      final rows = await _dataSource.getNotifications();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      await _dataSource.markAllAsRead();
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, ReminderSettings>> getReminderSettings() async {
    try {
      final model = await _dataSource.getReminderSettings();
      return Right(model.toEntity());
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, ReminderSettings>> updateReminderSettings(
      ReminderSettings settings) async {
    try {
      final model = await _dataSource.updateReminderSettings(
        ReminderSettingsModel(
          dailyExpenseReminder: settings.dailyExpenseReminder,
          budgetAlertReminder: settings.budgetAlertReminder,
          recurringAlertReminder: settings.recurringAlertReminder,
          dailyReminderTime: settings.dailyReminderTime,
        ),
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }
}
