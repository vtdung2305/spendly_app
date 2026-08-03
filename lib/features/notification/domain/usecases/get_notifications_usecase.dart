import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/notification/domain/entities/notification_item.dart';
import 'package:spendly_app/features/notification/domain/repositories/i_notification_repository.dart';

class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);
  final INotificationRepository _repository;

  Future<Either<Failure, List<NotificationItem>>> call() =>
      _repository.getNotifications();
}
