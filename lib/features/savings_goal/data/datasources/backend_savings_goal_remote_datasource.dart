import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/core/utils/num_parsing.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';

/// Custom backend's `/api/v1/savings-goals/:year` — already returns
/// `targetAmount`/`currentAmount`/`percent` precomputed, no client math.
/// The same response also carries `deadline`/`avgPerMonth`/`history`, used
/// by [getContributionHistory] for the Savings Goal Detail screen.
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

  Future<SavingsGoal> createSavingsGoal(int year, double targetAmount) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      'savings-goals',
      data: {'year': year, 'targetAmount': targetAmount},
    );
    return _fromJson(
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>);
  }

  Future<SavingsGoal> updateSavingsGoal(int year, double targetAmount) async {
    final response = await _client.dio.patch<Map<String, dynamic>>(
      'savings-goals/$year',
      data: {'targetAmount': targetAmount},
    );
    return _fromJson(
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>);
  }

  /// `history` entries are per elapsed month, most recent first, and only
  /// carry `date`/`amount` — [SavingsContribution.year]/`.month` are
  /// derived from `date` since the backend doesn't send them separately.
  Future<List<SavingsContribution>> getContributionHistory(int year) async {
    final response =
        await _client.dio.get<Map<String, dynamic>>('savings-goals/$year');
    final json =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>;
    final history = json['history'] as List<dynamic>? ?? [];
    return [
      for (final entry in history.cast<Map<String, dynamic>>())
        SavingsContribution(
          year: DateTime.parse(entry['date'] as String).year,
          month: DateTime.parse(entry['date'] as String).month,
          amount: parseNum(entry['amount']),
        ),
    ];
  }

  SavingsGoal _fromJson(Map<String, dynamic> json) => SavingsGoal(
        year: parseNum(json['year']).toInt(),
        targetAmount: parseNum(json['targetAmount']),
        currentAmount: parseNum(json['currentAmount']),
        percent: parseNum(json['percent']),
      );
}
