/// `GET/PATCH /notifications/reminder-settings` — [dailyReminderTime] is
/// one of `"08:00"`, `"12:00"`, `"20:00"` per the backend contract.
class ReminderSettings {
  const ReminderSettings({
    required this.dailyExpenseReminder,
    required this.budgetAlertReminder,
    required this.recurringAlertReminder,
    required this.dailyReminderTime,
  });

  final bool dailyExpenseReminder;
  final bool budgetAlertReminder;
  final bool recurringAlertReminder;
  final String dailyReminderTime;

  ReminderSettings copyWith({
    bool? dailyExpenseReminder,
    bool? budgetAlertReminder,
    bool? recurringAlertReminder,
    String? dailyReminderTime,
  }) {
    return ReminderSettings(
      dailyExpenseReminder: dailyExpenseReminder ?? this.dailyExpenseReminder,
      budgetAlertReminder: budgetAlertReminder ?? this.budgetAlertReminder,
      recurringAlertReminder:
          recurringAlertReminder ?? this.recurringAlertReminder,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
    );
  }
}
