import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase `public.profiles.savings_goal_amount` — a single year-agnostic
/// target (unlike the custom backend's real per-year resource). Moved here
/// from the authentication feature, which no longer owns this concept.
class SavingsGoalRemoteDataSource {
  SavingsGoalRemoteDataSource(this._client);

  final SupabaseClient _client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const AuthException('Chưa đăng nhập');
    return id;
  }

  Future<double> getTargetAmount() async {
    final row = await _client
        .from('profiles')
        .select('savings_goal_amount')
        .eq('id', _userId)
        .single();
    return (row['savings_goal_amount'] as num?)?.toDouble() ?? 0;
  }

  Future<void> setTargetAmount(double amount) async {
    await _client
        .from('profiles')
        .update({'savings_goal_amount': amount}).eq('id', _userId);
  }
}
