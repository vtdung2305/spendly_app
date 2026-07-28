import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';
import 'package:spendly_app/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:spendly_app/features/transactions/domain/entities/expense_category.dart';

class BudgetRepository implements IBudgetRepository {
  const BudgetRepository(this._budgetDataSource, this._transactionDataSource);

  final BudgetRemoteDataSource _budgetDataSource;
  final TransactionRemoteDataSource _transactionDataSource;

  @override
  Future<Either<Failure, List<BudgetItem>>> getBudgets() async {
    try {
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month);
      final monthEnd = DateTime(now.year, now.month + 1);

      final rows = await _budgetDataSource.getBudgetRows();
      final monthTransactions = await _transactionDataSource
          .getTransactionsInRange(monthStart, monthEnd);

      final usedByCategory = <String, double>{};
      for (final t in monthTransactions) {
        if (t.type != TransactionType.expense) continue;
        final key = t.expenseCategory!.name;
        usedByCategory[key] = (usedByCategory[key] ?? 0) + t.amount;
      }

      final items = rows
          .map((row) => BudgetItem(
                category: row.category,
                budgetAmount: row.budgetAmount,
                usedAmount: usedByCategory[row.category.name] ?? 0,
              ))
          .toList();
      return Right(items);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addBudget(
      ExpenseCategory category, double amount) async {
    try {
      await _budgetDataSource.upsertBudget(category, amount);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget(ExpenseCategory category) async {
    try {
      await _budgetDataSource.deleteBudget(category);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
