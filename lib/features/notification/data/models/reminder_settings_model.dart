import 'package:spendly_app/features/notification/domain/entities/reminder_settings.dart';

class ReminderSettingsModel {
  const ReminderSettingsModel({
    required this.dailyExpenseReminder,
    required this.budgetAlertReminder,
    required this.recurringAlertReminder,
    required this.dailyReminderTime,
  });

  factory ReminderSettingsModel.fromBackendJson(Map<String, dynamic> json) =>
      ReminderSettingsModel(
        dailyExpenseReminder: json['dailyExpenseReminder'] as bool,
        budgetAlertReminder: json['budgetAlertReminder'] as bool,
        recurringAlertReminder: json['recurringAlertReminder'] as bool,
        dailyReminderTime: json['dailyReminderTime'] as String,
      );

  final bool dailyExpenseReminder;
  final bool budgetAlertReminder;
  final bool recurringAlertReminder;
  final String dailyReminderTime;

  Map<String, dynamic> toBackendJson() => {
        'dailyExpenseReminder': dailyExpenseReminder,
        'budgetAlertReminder': budgetAlertReminder,
        'recurringAlertReminder': recurringAlertReminder,
        'dailyReminderTime': dailyReminderTime,
      };

  ReminderSettings toEntity() => ReminderSettings(
        dailyExpenseReminder: dailyExpenseReminder,
        budgetAlertReminder: budgetAlertReminder,
        recurringAlertReminder: recurringAlertReminder,
        dailyReminderTime: dailyReminderTime,
      );
}
