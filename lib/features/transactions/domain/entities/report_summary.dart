import 'dashboard_summary.dart';

class WeekBar {
  const WeekBar({required this.label, required this.percent});
  final String label;
  final double percent;
}

/// Aggregated stats backing the Reports screen — mini stat cards, category
/// pie, and weekly bar chart.
class ReportSummary {
  const ReportSummary({
    required this.topCategory,
    required this.avgPerDay,
    required this.maxSpendDay,
    required this.savingsRatePercent,
    required this.categoryBreakdown,
    required this.weekBars,
  });

  /// Null when there's no expense data for the period; never the synthetic
  /// "Khác" aggregate row (always the largest *real* category, if any).
  final CategoryShare? topCategory;
  final double avgPerDay;
  final double maxSpendDay;
  final double savingsRatePercent;
  final List<CategoryShare> categoryBreakdown;
  final List<WeekBar> weekBars;
}
