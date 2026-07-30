import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';

/// Custom backend's `/api/v1/budgets` — rows already carry `limitAmount`/
/// `spentAmount`/`usedPercent` and an embedded `category` object, so no
/// client-side monthly aggregation is needed (unlike Supabase mode).
class BackendBudgetRemoteDataSource {
  BackendBudgetRemoteDataSource(this._client);

  final BackendApiClient _client;

  Future<List<Map<String, dynamic>>> getBudgetRows(String month) async {
    final response = await _client.dio.get<Map<String, dynamic>>('budgets',
        queryParameters: {'month': month});
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> createBudget(
      String categoryId, String month, double limitAmount) async {
    await _client.dio.post('budgets', data: {
      'categoryId': categoryId,
      'month': month,
      'limitAmount': limitAmount,
    });
  }

  Future<void> updateBudget(String id, double limitAmount) async {
    await _client.dio.patch('budgets/$id', data: {'limitAmount': limitAmount});
  }

  Future<void> deleteBudget(String id) async {
    await _client.dio.delete('budgets/$id');
  }
}
