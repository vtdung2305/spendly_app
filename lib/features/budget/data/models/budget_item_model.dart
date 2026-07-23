import '../../../transactions/domain/entities/expense_category.dart';
import '../../domain/entities/budget_item.dart';

class BudgetItemModel {
  const BudgetItemModel({
    required this.category,
    required this.budgetAmount,
    required this.usedAmount,
  });

  final ExpenseCategory category;
  final double budgetAmount;
  final double usedAmount;

  BudgetItem toEntity() => BudgetItem(
        category: category,
        budgetAmount: budgetAmount,
        usedAmount: usedAmount,
      );
}
