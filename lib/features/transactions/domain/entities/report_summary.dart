import 'chart_category_group.dart';
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
    required this.topCategoryGroup,
    required this.avgPerDay,
    required this.maxSpendDay,
    required this.savingsRatePercent,
    required this.categoryBreakdown,
    required this.weekBars,
  });

  /// Null when there's no expense data for the period — presentation maps
  /// this to a localized label (or a "—" placeholder) via
  /// `ChartCategoryGroupUi.labelText`.
  final ChartCategoryGroup? topCategoryGroup;
  final double avgPerDay;
  final double maxSpendDay;
  final double savingsRatePercent;
  final List<CategoryShare> categoryBreakdown;
  final List<WeekBar> weekBars;
}
