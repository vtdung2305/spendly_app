/// The 4 income sources offered on Add Transaction, per design handoff.
/// Pure Dart — icon mapping lives in the presentation layer
/// (`presentation/mappers/income_source_ui.dart`).
enum IncomeSource {
  luong('Lương'),
  freelance('Freelance'),
  bonus('Bonus'),
  khac('Khác');

  const IncomeSource(this.label);

  final String label;
}
