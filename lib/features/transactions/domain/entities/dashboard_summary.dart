import 'chart_category_group.dart';
import 'transaction.dart';

class CategoryShare {
  const CategoryShare({required this.group, required this.percent});
  final ChartCategoryGroup group;
  final double percent;
}

class DailySpendPoint {
  const DailySpendPoint({required this.day, required this.total});
  final int day;
  final double total;
}

/// Aggregated data backing the Dashboard screen — hero card, budget ring,
/// category pie, daily spend bars, recent transactions list.
class DashboardSummary {
  const DashboardSummary({
    required this.monthLabel,
    required this.totalIncome,
    required this.totalExpense,
    required this.budgetTotal,
    required this.budgetUsed,
    required this.categoryBreakdown,
    required this.dailySpend,
    required this.recentTransactions,
  });

  final String monthLabel;
  final double totalIncome;
  final double totalExpense;
  final double budgetTotal;
  final double budgetUsed;
  final List<CategoryShare> categoryBreakdown;
  final List<DailySpendPoint> dailySpend;
  final List<Transaction> recentTransactions;

  double get savings => totalIncome - totalExpense;
  double get budgetRemaining => budgetTotal - budgetUsed;
  int get budgetUsedPercent =>
      budgetTotal == 0 ? 0 : ((budgetUsed / budgetTotal) * 100).round();
}
