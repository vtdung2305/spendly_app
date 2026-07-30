import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';

/// Number of real categories shown individually in a breakdown pie/legend
/// before the remainder is folded into one "Khác" aggregate row.
const kBreakdownTopN = 5;

/// Groups pre-summed per-category amounts, sorted descending, keeping the
/// top [topN] individually and folding any remainder into one synthetic
/// `isOther` ("Khác") row appended last. Shared by the Supabase and Backend
/// transaction repositories — both compute category totals differently, but
/// the top-N-plus-Other presentation shape is identical.
List<CategoryShare> foldCategoryBreakdown(
  Map<String, double> amountByCategoryId,
  Map<String, Category> categoryById,
  double totalExpense, {
  int topN = kBreakdownTopN,
}) {
  final sorted = amountByCategoryId.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  double percentOf(double amount) =>
      totalExpense == 0 ? 0 : (amount / totalExpense) * 100;

  final shares = [
    for (final entry in sorted.take(topN))
      CategoryShare(
        category: categoryById[entry.key],
        amount: entry.value,
        percent: percentOf(entry.value),
      ),
  ];

  if (sorted.length > topN) {
    final otherAmount =
        sorted.skip(topN).fold<double>(0, (sum, e) => sum + e.value);
    shares.add(CategoryShare(
      isOther: true,
      amount: otherAmount,
      percent: percentOf(otherAmount),
    ));
  }

  return shares;
}
