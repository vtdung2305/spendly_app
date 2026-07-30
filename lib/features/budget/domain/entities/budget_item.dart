import 'package:spendly_app/features/category_management/domain/entities/category.dart';

/// One category's monthly budget vs. actual spend, for the Budget screen.
class BudgetItem {
  const BudgetItem({
    required this.category,
    required this.budgetAmount,
    required this.usedAmount,
  });

  final Category category;
  final double budgetAmount;
  final double usedAmount;

  int get usedPercent =>
      budgetAmount == 0 ? 0 : ((usedAmount / budgetAmount) * 100).round();

  bool get isOverBudget => usedPercent > 100;
}
