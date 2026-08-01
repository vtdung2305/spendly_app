import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';
import 'package:spendly_app/features/category_management/data/datasources/category_remote_datasource.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

class BudgetRepository implements IBudgetRepository {
  const BudgetRepository(this._budgetDataSource, this._transactionDataSource,
      this._categoryDataSource);

  final BudgetRemoteDataSource _budgetDataSource;
  final TransactionRemoteDataSource _transactionDataSource;
  final CategoryRemoteDataSource _categoryDataSource;

  @override
  Future<Either<Failure, List<BudgetItem>>> getBudgets(DateTime month) async {
    try {
      final monthStart = DateTime(month.year, month.month);
      final monthEnd = DateTime(month.year, month.month + 1);

      final rows = await _budgetDataSource.getBudgetRows();
      final monthTransactions = await _transactionDataSource
          .getTransactionsInRange(monthStart, monthEnd);
      final categories = await _categoryDataSource.getCategories();
      final categoryById = {for (final c in categories) c.id: c.toEntity()};

      final usedByCategoryId = <String, double>{};
      for (final t in monthTransactions) {
        if (t.type != TransactionType.expense || t.categoryId == null) {
          continue;
        }
        usedByCategoryId[t.categoryId!] =
            (usedByCategoryId[t.categoryId!] ?? 0) + t.amount;
      }

      final items = [
        for (final row in rows)
          if (categoryById[row.categoryId] case final Category category)
            BudgetItem(
              category: category,
              budgetAmount: row.budgetAmount,
              usedAmount: usedByCategoryId[row.categoryId] ?? 0,
            ),
      ];
      return Right(items);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addBudget(
      Category category, double amount) async {
    try {
      await _budgetDataSource.upsertBudget(category.id, amount);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget(Category category) async {
    try {
      await _budgetDataSource.deleteBudget(category.id);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
