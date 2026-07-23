import '../../../transactions/domain/entities/expense_category.dart';
import '../models/budget_item_model.dart';

/// Matches design handoff `budgets` verbatim — Giải trí is intentionally
/// over budget (1.690.000 / 1.500.000 = 113%) to exercise the danger state.
class BudgetMockDataSource {
  Future<List<BudgetItemModel>> getBudgets() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const [
      BudgetItemModel(category: ExpenseCategory.anUong, budgetAmount: 5000000, usedAmount: 4250000),
      BudgetItemModel(category: ExpenseCategory.shopping, budgetAmount: 3000000, usedAmount: 2860000),
      BudgetItemModel(category: ExpenseCategory.diLai, budgetAmount: 2000000, usedAmount: 1120000),
      BudgetItemModel(category: ExpenseCategory.giaiTri, budgetAmount: 1500000, usedAmount: 1690000),
      BudgetItemModel(category: ExpenseCategory.giaDinh, budgetAmount: 4000000, usedAmount: 2380000),
    ];
  }
}
