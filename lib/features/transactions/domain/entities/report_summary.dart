import 'dashboard_summary.dart';

class ChartBar {
  const ChartBar({required this.label, required this.percent});
  final String label;
  final double percent;
}

/// Aggregated stats backing the Reports screen — comparison card, mini stat
/// cards, category pie, and period bar chart.
class ReportSummary {
  const ReportSummary({
    required this.totalIncome,
    required this.totalExpense,
    this.incomeDeltaPercent,
    this.expenseDeltaPercent,
    required this.topCategory,
    required this.avgPerDay,
    required this.maxSpendDay,
    required this.savingsRatePercent,
    required this.categoryBreakdown,
    required this.chartBars,
  });

  final double totalIncome;
  final double totalExpense;

  /// Percent change vs. the previous period of equal length. Null when the
  /// previous period has no income/expense to compare against.
  final double? incomeDeltaPercent;
  final double? expenseDeltaPercent;

  /// Null when there's no expense data for the period; never the synthetic
  /// "Khác" aggregate row (always the largest *real* category, if any).
  final CategoryShare? topCategory;
  final double avgPerDay;
  final double maxSpendDay;
  final double savingsRatePercent;
  final List<CategoryShare> categoryBreakdown;
  final List<ChartBar> chartBars;

  double get netSavings => totalIncome - totalExpense;
  int get expensePercentOfIncome =>
      totalIncome == 0 ? 0 : ((totalExpense / totalIncome) * 100).round().clamp(0, 100);
}
