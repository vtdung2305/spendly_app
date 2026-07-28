import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spendly_app/features/transactions/domain/entities/expense_category.dart';

typedef BudgetRow = ({ExpenseCategory category, double budgetAmount});

/// Supabase Postgrest access to `public.budgets` — just the per-category
/// budget ceilings. `used` amounts are computed by the repository from
/// `transactions`, never stored here.
class BudgetRemoteDataSource {
  BudgetRemoteDataSource(this._client);

  final SupabaseClient _client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const AuthException('Chưa đăng nhập');
    return id;
  }

  Future<List<BudgetRow>> getBudgetRows() async {
    final rows = await _client.from('budgets').select().eq('user_id', _userId);
    return (rows as List).map((r) {
      final json = r as Map<String, dynamic>;
      return (
        category: ExpenseCategory.values.byName(json['category'] as String),
        budgetAmount: (json['budget_amount'] as num).toDouble(),
      );
    }).toList();
  }

  Future<void> upsertBudget(ExpenseCategory category, double amount) async {
    await _client.from('budgets').upsert(
      {'user_id': _userId, 'category': category.name, 'budget_amount': amount},
      onConflict: 'user_id,category',
    );
  }

  Future<void> deleteBudget(ExpenseCategory category) async {
    await _client
        .from('budgets')
        .delete()
        .eq('user_id', _userId)
        .eq('category', category.name);
  }
}
