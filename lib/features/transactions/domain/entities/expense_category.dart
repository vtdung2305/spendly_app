import 'chart_category_group.dart';

/// The 8 expense categories offered on Add Transaction, per design handoff.
/// Pure Dart — icon mapping lives in the presentation layer
/// (`presentation/mappers/expense_category_ui.dart`). [chartGroup] buckets
/// the long-tail categories (yTe/duLich/thuCung) under the shared "Khác"
/// slice used by Dashboard/Reports pie charts.
enum ExpenseCategory {
  anUong('Ăn uống', ChartCategoryGroup.anUong),
  shopping('Shopping', ChartCategoryGroup.shopping),
  diLai('Đi lại', ChartCategoryGroup.diLai),
  giaiTri('Giải trí', ChartCategoryGroup.giaiTri),
  yTe('Y tế', ChartCategoryGroup.khac),
  giaDinh('Gia đình', ChartCategoryGroup.giaDinh),
  duLich('Du lịch', ChartCategoryGroup.khac),
  thuCung('Thú cưng', ChartCategoryGroup.khac);

  const ExpenseCategory(this.label, this.chartGroup);

  final String label;
  final ChartCategoryGroup chartGroup;
}
