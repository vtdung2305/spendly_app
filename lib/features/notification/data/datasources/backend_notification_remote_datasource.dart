import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/features/notification/data/models/notification_model.dart';
import 'package:spendly_app/features/notification/data/models/reminder_settings_model.dart';

/// Custom backend's `/api/v1/notifications` — the Notification Center
/// (screen 10d) only shows "recent" notifications, so this fetches a
/// single page rather than following `meta.cursor` exhaustively like
/// Transaction History does.
class BackendNotificationRemoteDataSource {
  BackendNotificationRemoteDataSource(this._client);

  final BackendApiClient _client;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      'notifications',
      queryParameters: {'limit': 50},
    );
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as List<dynamic>;
    return data
        .map((r) =>
            NotificationModel.fromBackendJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAllAsRead() async {
    await _client.dio.patch('notifications/mark-all-read');
  }

  Future<ReminderSettingsModel> getReminderSettings() async {
    final response = await _client.dio
        .get<Map<String, dynamic>>('notifications/reminder-settings');
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>;
    return ReminderSettingsModel.fromBackendJson(data);
  }

  Future<ReminderSettingsModel> updateReminderSettings(
      ReminderSettingsModel settings) async {
    final response = await _client.dio.patch<Map<String, dynamic>>(
      'notifications/reminder-settings',
      data: settings.toBackendJson(),
    );
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>;
    return ReminderSettingsModel.fromBackendJson(data);
  }
}
