import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/features/recurring_transaction/data/models/recurring_transaction_model.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// Custom backend's `/api/v1/recurring-transactions` — the backend itself
/// auto-generates real `Transaction`s daily for active rows; this
/// datasource only manages the recurring rule rows themselves.
class BackendRecurringTransactionRemoteDataSource {
  BackendRecurringTransactionRemoteDataSource(this._client);

  final BackendApiClient _client;

  Future<List<RecurringTransactionModel>> getRecurringTransactions() async {
    final response =
        await _client.dio.get<Map<String, dynamic>>('recurring-transactions');
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as List<dynamic>;
    return data
        .map((r) =>
            RecurringTransactionModel.fromBackendJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Doesn't parse/return the created row — some deployments of this
  /// endpoint respond with `data: null` on success, and the list screen
  /// always does a full `GET` reload after returning from the form
  /// anyway, so there's nothing useful to build from the POST body.
  Future<void> addRecurringTransaction({
    required TransactionType type,
    required String categoryId,
    required String label,
    required double amount,
    required int dayOfMonth,
    required bool isActive,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      'recurring-transactions',
      data: {
        'type': type == TransactionType.income ? 'INCOME' : 'EXPENSE',
        'categoryId': categoryId,
        'label': label,
        'amount': amount,
        'dayOfMonth': dayOfMonth,
        'isActive': isActive,
      },
    );
    unwrapBackendData(response.data, statusCode: response.statusCode);
  }

  Future<void> updateRecurringTransaction(
    String id, {
    required TransactionType type,
    required String categoryId,
    required String label,
    required double amount,
    required int dayOfMonth,
    required bool isActive,
  }) async {
    final response = await _client.dio.patch<Map<String, dynamic>>(
      'recurring-transactions/$id',
      data: {
        'type': type == TransactionType.income ? 'INCOME' : 'EXPENSE',
        'categoryId': categoryId,
        'label': label,
        'amount': amount,
        'dayOfMonth': dayOfMonth,
        'isActive': isActive,
      },
    );
    unwrapBackendData(response.data, statusCode: response.statusCode);
  }

  Future<void> deleteRecurringTransaction(String id) async {
    await _client.dio.delete('recurring-transactions/$id');
  }
}
