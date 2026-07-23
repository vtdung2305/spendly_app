import '../models/transaction_model.dart';
import 'transaction_seed_data.dart';

/// In-memory stand-in for the Supabase `transactions`/`budgets` tables.
/// Seed values mirror the design handoff Dashboard reference exactly
/// (26.500.000₫ savings, 45M income, 18.5M expense, 62% budget used) so the
/// UI can be pixel-checked against the prototype before Supabase is wired up.
class TransactionMockDataSource {
  final List<TransactionModel> _transactions = TransactionSeedData.seed();
  final List<TransactionModel> _historyPool = TransactionSeedData.historyPool();
  final List<TransactionModel> _incomeList = TransactionSeedData.incomeListSeed();
  final List<double> _calendarAmounts = TransactionSeedData.calendarAmounts();

  // Independent of totalExpense — the budget ring tracks only
  // budget-assigned categories, per design handoff ("Đã dùng 62% · còn
  // 12.500.000 ₫" on a total that isn't the full month's expense).
  final double _budgetTotal = 32900000;
  final double _budgetUsed = 20400000;

  Future<List<TransactionModel>> getTransactionsForMonth(DateTime month) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _transactions
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .toList();
  }

  double get budgetTotal => _budgetTotal;
  double get budgetUsed => _budgetUsed;

  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _transactions.insert(0, transaction);
    _historyPool.insert(0, transaction);
    return transaction;
  }

  /// Backs Transaction History (all types) and Income Management
  /// (type filter applied by the repository).
  Future<List<TransactionModel>> getHistoryPool() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_historyPool);
  }

  /// Income Management's own curated list — per design handoff, the month
  /// chips are decorative and don't re-filter this list.
  Future<List<TransactionModel>> getIncomeList() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_incomeList);
  }

  Future<List<double>> getCalendarAmounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_calendarAmounts);
  }
}
