import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/core/utils/num_parsing.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';

/// Custom backend's `/api/v1/savings-goals/:year` — already returns
/// `targetAmount`/`currentAmount`/`percent` precomputed, no client math.
class BackendSavingsGoalRemoteDataSource {
  BackendSavingsGoalRemoteDataSource(this._client);

  final BackendApiClient _client;

  Future<SavingsGoal> getSavingsGoal(int year) async {
    final response =
        await _client.dio.get<Map<String, dynamic>>('savings-goals/$year');
    return _fromJson(
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>);
  }

  Future<SavingsGoal> updateSavingsGoal(int year, double targetAmount) async {
    final response = await _client.dio.put<Map<String, dynamic>>(
      'savings-goals/$year',
      data: {'targetAmount': targetAmount},
    );
    return _fromJson(
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>);
  }

  SavingsGoal _fromJson(Map<String, dynamic> json) => SavingsGoal(
        year: parseNum(json['year']).toInt(),
        targetAmount: parseNum(json['targetAmount']),
        currentAmount: parseNum(json['currentAmount']),
        percent: parseNum(json['percent']),
      );
}
