import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spendly_app/features/transactions/data/models/transaction_model.dart';

/// Supabase Postgrest access to `public.transactions`, scoped to the
/// signed-in user via RLS (every query still filters by user_id explicitly
/// too, so intent is clear without relying solely on the policy).
class TransactionRemoteDataSource {
  TransactionRemoteDataSource(this._client);

  final SupabaseClient _client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const AuthException('Chưa đăng nhập');
    return id;
  }

  Future<List<TransactionModel>> getTransactionsInRange(
      DateTime start, DateTime end) async {
    final rows = await _client
        .from('transactions')
        .select()
        .eq('user_id', _userId)
        .gte('date', _dateOnly(start))
        .lt('date', _dateOnly(end))
        .order('date');
    return (rows as List)
        .map((r) => TransactionModel.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final rows = await _client
        .from('transactions')
        .select()
        .eq('user_id', _userId)
        .order('date', ascending: false);
    return (rows as List)
        .map((r) => TransactionModel.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<TransactionModel> addTransaction(TransactionModel model) async {
    final payload = {...model.toInsertJson(), 'user_id': _userId};
    final row =
        await _client.from('transactions').insert(payload).select().single();
    return TransactionModel.fromJson(row);
  }

  Future<void> updateTransaction(TransactionModel model) async {
    await _client
        .from('transactions')
        .update(model.toInsertJson())
        .eq('id', model.id)
        .eq('user_id', _userId);
  }

  Future<void> deleteTransaction(String id) async {
    await _client
        .from('transactions')
        .delete()
        .eq('id', id)
        .eq('user_id', _userId);
  }

  String _dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
