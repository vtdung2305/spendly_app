/// The 6 fixed buckets used by every pie/legend in the app (Dashboard,
/// Reports) — pure Dart. Colors are assigned in the presentation layer
/// (`presentation/mappers/chart_category_group_ui.dart`).
enum ChartCategoryGroup {
  anUong('Ăn uống'),
  shopping('Shopping'),
  diLai('Đi lại'),
  giaiTri('Giải trí'),
  giaDinh('Gia đình'),
  khac('Khác');

  const ChartCategoryGroup(this.label);

  final String label;
}
