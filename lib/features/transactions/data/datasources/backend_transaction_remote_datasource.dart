import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/core/utils/num_parsing.dart';
import 'package:spendly_app/features/transactions/data/models/transaction_model.dart';
import 'package:spendly_app/features/transactions/domain/entities/calendar_day.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// Custom backend's `/api/v1/transactions` + `/transactions/summary/*` +
/// `/dashboard/summary`. Composite summary endpoints return their raw JSON
/// map — the repository does the domain mapping (category resolution,
/// top-N folding), matching how `TransactionRepository` splits transport
/// from aggregation on the Supabase side.
class BackendTransactionRemoteDataSource {
  BackendTransactionRemoteDataSource(this._client);

  final BackendApiClient _client;

  Future<TransactionModel> addTransaction(TransactionModel model) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
        'transactions',
        data: model.toBackendJson());
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as Map<String, dynamic>;
    return TransactionModel.fromBackendJson(data);
  }

  Future<void> updateTransaction(TransactionModel model) async {
    await _client.dio
        .patch('transactions/${model.id}', data: model.toBackendJson());
  }

  Future<void> deleteTransaction(String id) async {
    await _client.dio.delete('transactions/$id');
  }

  /// Follows `meta.cursor` until `hasMore == false`, capped at 20 pages
  /// (2000 rows) to bound worst-case history size.
  Future<List<TransactionModel>> getTransactions({
    TransactionType? type,
    String? dateFrom,
    String? dateTo,
    String? search,
  }) async {
    final results = <TransactionModel>[];
    String? cursor;
    for (var page = 0; page < 20; page++) {
      final query = <String, dynamic>{'limit': 100};
      if (type != null) {
        query['type'] = type == TransactionType.income ? 'INCOME' : 'EXPENSE';
      }
      if (dateFrom != null) query['dateFrom'] = dateFrom;
      if (dateTo != null) query['dateTo'] = dateTo;
      if (search != null && search.isNotEmpty) query['search'] = search;
      if (cursor != null) query['cursor'] = cursor;

      final response = await _client.dio
          .get<Map<String, dynamic>>('transactions', queryParameters: query);
      final body = response.data!;
      final data = unwrapBackendData(body, statusCode: response.statusCode)
          as List<dynamic>;
      results.addAll(data.map(
          (r) => TransactionModel.fromBackendJson(r as Map<String, dynamic>)));

      final meta = body['meta'] as Map<String, dynamic>?;
      final hasMore = meta?['hasMore'] as bool? ?? false;
      cursor = meta?['cursor'] as String?;
      if (!hasMore || cursor == null) break;
    }
    return results;
  }

  Future<List<CalendarDay>> getDailySummary(DateTime month) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      'transactions/summary/daily',
      queryParameters: {'month': _monthString(month)},
    );
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as List<dynamic>;
    return data.map((r) {
      final json = r as Map<String, dynamic>;
      final date = DateTime.parse(json['date'] as String);
      return CalendarDay(day: date.day, amount: parseNum(json['total']));
    }).toList();
  }

  Future<Map<String, dynamic>> getPeriodSummary(
      String period, String date) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      'transactions/summary/period',
      queryParameters: {'period': period, 'date': date},
    );
    return unwrapBackendData(response.data, statusCode: response.statusCode)
        as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDashboardSummary(DateTime month) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      'dashboard/summary',
      queryParameters: {'month': _monthString(month)},
    );
    return unwrapBackendData(response.data, statusCode: response.statusCode)
        as Map<String, dynamic>;
  }

  String _monthString(DateTime month) =>
      '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';
}
