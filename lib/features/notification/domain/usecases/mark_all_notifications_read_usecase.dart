import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/notification/domain/repositories/i_notification_repository.dart';

class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);
  final INotificationRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.markAllAsRead();
}
