import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/notification/domain/entities/reminder_settings.dart';
import 'package:spendly_app/features/notification/domain/repositories/i_notification_repository.dart';

class UpdateReminderSettingsUseCase {
  const UpdateReminderSettingsUseCase(this._repository);
  final INotificationRepository _repository;

  Future<Either<Failure, ReminderSettings>> call(ReminderSettings settings) =>
      _repository.updateReminderSettings(settings);
}
