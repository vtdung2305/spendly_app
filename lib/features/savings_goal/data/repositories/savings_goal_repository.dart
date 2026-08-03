import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/data/datasources/savings_goal_remote_datasource.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';
import 'package:spendly_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/data/models/transaction_model.dart';
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

  /// Supabase only ever stores one year-agnostic target
  /// (`profiles.savings_goal_amount`), so "create for a year" and "update
  /// the target" are the same write here — unlike backend mode, which
  /// rejects a duplicate year.
  @override
  Future<Either<Failure, SavingsGoal>> addSavingsGoal(
          int year, double targetAmount) =>
      updateSavingsGoal(year, targetAmount);

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

  @override
  Future<Either<Failure, List<SavingsContribution>>> getContributionHistory(
      int year) async {
    try {
      final start = DateTime(year);
      final end = DateTime(year + 1);
      final rows =
          await _transactionDataSource.getTransactionsInRange(start, end);
      return Right(_groupByMonth(rows, year));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Net savings per month, most recent month first.
  List<SavingsContribution> _groupByMonth(
      List<TransactionModel> transactions, int year) {
    final byMonth = <int, double>{};
    for (final t in transactions) {
      byMonth[t.date.month] = (byMonth[t.date.month] ?? 0) +
          (t.type == TransactionType.income ? t.amount : -t.amount);
    }
    final months = byMonth.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final month in months)
        SavingsContribution(year: year, month: month, amount: byMonth[month]!),
    ];
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
