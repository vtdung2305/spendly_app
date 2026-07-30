import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/data/datasources/savings_goal_remote_datasource.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';
import 'package:spendly_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

class SavingsGoalRepository implements ISavingsGoalRepository {
  const SavingsGoalRepository(this._dataSource, this._transactionDataSource);

  final SavingsGoalRemoteDataSource _dataSource;
  final TransactionRemoteDataSource _transactionDataSource;

  @override
  Future<Either<Failure, SavingsGoal>> getSavingsGoal(int year) async {
    try {
      final targetAmount = await _dataSource.getTargetAmount();
      final currentAmount = await _yearToDateSavings(year);
      return Right(_toSavingsGoal(year, targetAmount, currentAmount));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(
      int year, double targetAmount) async {
    try {
      await _dataSource.setTargetAmount(targetAmount);
      final currentAmount = await _yearToDateSavings(year);
      return Right(_toSavingsGoal(year, targetAmount, currentAmount));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Net savings (income − expense) from Jan 1 of [year] through today.
  Future<double> _yearToDateSavings(int year) async {
    final start = DateTime(year);
    final now = DateTime.now();
    final end = now.add(const Duration(days: 1));
    final rows =
        await _transactionDataSource.getTransactionsInRange(start, end);

    var savings = 0.0;
    for (final row in rows) {
      savings += row.type == TransactionType.income ? row.amount : -row.amount;
    }
    return savings;
  }

  SavingsGoal _toSavingsGoal(
      int year, double targetAmount, double currentAmount) {
    final percent = targetAmount <= 0
        ? 0.0
        : (currentAmount / targetAmount * 100).clamp(0, 999).toDouble();
    return SavingsGoal(
      year: year,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      percent: percent,
    );
  }
}
