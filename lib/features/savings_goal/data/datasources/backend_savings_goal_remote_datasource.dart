import 'package:intl/intl.dart';

import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/core/utils/num_parsing.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';

/// Custom backend's `/api/v1/savings-goals` (v3) — id-keyed, multi-goal,
/// free-form `deadline`. `GET /:id` already returns `history` inline, used
/// by [getContributionHistory] for the Savings Goal Detail screen.
class BackendSavingsGoalRemoteDataSource {
  BackendSavingsGoalRemoteDataSource(this._client);

  final BackendApiClient _client;

  /// Sorted nearest-deadline-first by the backend — used by
  /// [getNearestGoal] to pick the Dashboard's "current" goal.
  Future<List<SavingsGoal>> getSavingsGoals() async {
    final response =
        await _client.dio.get<Map<String, dynamic>>('savings-goals');
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as List<dynamic>;
    return data
        .map((r) => _fromJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<SavingsGoal> getSavingsGoal(String id) async {
    final response =
        await _client.dio.get<Map<String, dynamic>>('savings-goals/$id');
    return _fromJson(
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>);
  }

  Future<SavingsGoal> createSavingsGoal({
    required String name,
    required double targetAmount,
    required DateTime deadline,
    double initialAmount = 0,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      'savings-goals',
      data: {
        'name': name,
        'targetAmount': targetAmount,
        'deadline': _dateOnly(deadline),
        'initialAmount': initialAmount,
      },
    );
    return _fromJson(
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>);
  }

  Future<SavingsGoal> updateSavingsGoal(SavingsGoal goal) async {
    final response = await _client.dio.patch<Map<String, dynamic>>(
      'savings-goals/${goal.id}',
      data: {
        'name': goal.name,
        'targetAmount': goal.targetAmount,
        'deadline': _dateOnly(goal.deadline),
        'initialAmount': goal.initialAmount,
      },
    );
    return _fromJson(
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>);
  }

  Future<void> deleteSavingsGoal(String id) async {
    await _client.dio.delete('savings-goals/$id');
  }

  /// `history` entries are per elapsed month, most recent first, and only
  /// carry `date`/`amount` — [SavingsContribution.year]/`.month` are
  /// derived from `date` since the backend doesn't send them separately.
  Future<List<SavingsContribution>> getContributionHistory(String id) async {
    final response =
        await _client.dio.get<Map<String, dynamic>>('savings-goals/$id');
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

  String _dateOnly(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  SavingsGoal _fromJson(Map<String, dynamic> json) => SavingsGoal(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        targetAmount: parseNum(json['targetAmount']),
        initialAmount: parseNum(json['initialAmount']),
        currentAmount: parseNum(json['currentAmount']),
        percent: parseNum(json['percent']),
        deadline: DateTime.parse(json['deadline'] as String),
      );
}
