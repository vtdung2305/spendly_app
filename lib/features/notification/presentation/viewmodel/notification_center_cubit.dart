import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/notification/domain/entities/reminder_settings.dart';
import 'package:spendly_app/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:spendly_app/features/notification/domain/usecases/get_reminder_settings_usecase.dart';
import 'package:spendly_app/features/notification/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:spendly_app/features/notification/domain/usecases/update_reminder_settings_usecase.dart';
import 'notification_center_state.dart';

class NotificationCenterCubit extends Cubit<NotificationCenterState> {
  NotificationCenterCubit(
    this._getNotificationsUseCase,
    this._markAllNotificationsReadUseCase,
    this._getReminderSettingsUseCase,
    this._updateReminderSettingsUseCase,
  ) : super(const NotificationCenterLoading());

  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;
  final GetReminderSettingsUseCase _getReminderSettingsUseCase;
  final UpdateReminderSettingsUseCase _updateReminderSettingsUseCase;

  Future<void> load() async {
    emit(const NotificationCenterLoading());
    final notificationsResult = await _getNotificationsUseCase();
    final settingsResult = await _getReminderSettingsUseCase();
    notificationsResult.fold(
      (failure) => emit(NotificationCenterError(failure.message)),
      (notifications) => settingsResult.fold(
        (failure) => emit(NotificationCenterError(failure.message)),
        (settings) =>
            emit(NotificationCenterLoaded(notifications, settings)),
      ),
    );
  }

  Future<void> markAllAsRead() async {
    final current = state;
    if (current is! NotificationCenterLoaded) return;
    final result = await _markAllNotificationsReadUseCase();
    result.fold(
      (_) {},
      (_) => load(),
    );
  }

  Future<void> _updateSettings(ReminderSettings settings) async {
    final current = state;
    if (current is! NotificationCenterLoaded) return;
    final result = await _updateReminderSettingsUseCase(settings);
    result.fold(
      (_) {},
      (updated) =>
          emit(NotificationCenterLoaded(current.notifications, updated)),
    );
  }

  Future<void> toggleDailyExpenseReminder() async {
    final current = state;
    if (current is! NotificationCenterLoaded) return;
    await _updateSettings(current.settings.copyWith(
        dailyExpenseReminder: !current.settings.dailyExpenseReminder));
  }

  Future<void> toggleBudgetAlertReminder() async {
    final current = state;
    if (current is! NotificationCenterLoaded) return;
    await _updateSettings(current.settings.copyWith(
        budgetAlertReminder: !current.settings.budgetAlertReminder));
  }

  Future<void> toggleRecurringAlertReminder() async {
    final current = state;
    if (current is! NotificationCenterLoaded) return;
    await _updateSettings(current.settings.copyWith(
        recurringAlertReminder: !current.settings.recurringAlertReminder));
  }

  Future<void> selectDailyReminderTime(String time) async {
    final current = state;
    if (current is! NotificationCenterLoaded) return;
    await _updateSettings(
        current.settings.copyWith(dailyReminderTime: time));
  }
}
