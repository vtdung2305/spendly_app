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
    required this.topCategoryLabel,
    required this.avgPerDay,
    required this.maxSpendDay,
    required this.savingsRatePercent,
    required this.categoryBreakdown,
    required this.weekBars,
  });

  final String topCategoryLabel;
  final double avgPerDay;
  final double maxSpendDay;
  final double savingsRatePercent;
  final List<CategoryShare> categoryBreakdown;
  final List<WeekBar> weekBars;
}
