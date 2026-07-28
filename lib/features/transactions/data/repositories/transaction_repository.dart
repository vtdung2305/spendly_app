import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:spendly_app/features/transactions/domain/entities/calendar_day.dart';
import 'package:spendly_app/features/transactions/domain/entities/chart_category_group.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_summary.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:spendly_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/data/models/transaction_model.dart';

class TransactionRepository implements ITransactionRepository {
  const TransactionRepository(this._dataSource, this._budgetDataSource);

  final TransactionRemoteDataSource _dataSource;
  final BudgetRemoteDataSource _budgetDataSource;

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary(
      DateTime month) async {
    try {
      final monthStart = DateTime(month.year, month.month);
      final monthEnd = DateTime(month.year, month.month + 1);
      final transactions =
          (await _dataSource.getTransactionsInRange(monthStart, monthEnd))
              .map((r) => r.toEntity())
              .toList();

      final income =
          transactions.where((t) => t.type == TransactionType.income);
      final expenses =
          transactions.where((t) => t.type == TransactionType.expense).toList();
      final totalIncome = income.fold<double>(0, (sum, t) => sum + t.amount);
      final totalExpense = expenses.fold<double>(0, (sum, t) => sum + t.amount);

      final breakdown = _categoryBreakdown(expenses, totalExpense);

      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final dailyTotals = <int, double>{
        for (final d in expenses) d.date.day: 0
      };
      for (final t in expenses) {
        dailyTotals[t.date.day] = (dailyTotals[t.date.day] ?? 0) + t.amount;
      }
      final firstBarDay = (daysInMonth - 13).clamp(1, daysInMonth);
      final dailySpend = [
        for (var day = firstBarDay; day <= daysInMonth; day++)
          DailySpendPoint(day: day, total: dailyTotals[day] ?? 0),
      ];

      final recent = [...transactions]
        ..sort((a, b) => b.date.compareTo(a.date));

      final budgetRows = await _budgetDataSource.getBudgetRows();
      final budgetedCategories = budgetRows.map((r) => r.category).toSet();
      final budgetTotal =
          budgetRows.fold<double>(0, (sum, r) => sum + r.budgetAmount);
      final budgetUsed = expenses
          .where((t) => budgetedCategories.contains(t.expenseCategory))
          .fold<double>(0, (sum, t) => sum + t.amount);

      return Right(DashboardSummary(
        monthLabel: 'Tháng ${month.month}, ${month.year}',
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        budgetTotal: budgetTotal,
        budgetUsed: budgetUsed,
        categoryBreakdown: breakdown,
        dailySpend: dailySpend,
        recentTransactions: recent.take(10).toList(),
      ));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> addTransaction(
      Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final saved = await _dataSource.addTransaction(model);
      return Right(saved.toEntity());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({
    TransactionType? type,
    String? searchQuery,
  }) async {
    try {
      var transactions = (await _dataSource.getAllTransactions())
          .map((r) => r.toEntity())
          .toList();

      if (type != null) {
        transactions = transactions.where((t) => t.type == type).toList();
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        transactions = transactions
            .where(
                (t) => (t.note ?? t.displayLabel).toLowerCase().contains(query))
            .toList();
      }
      return Right(transactions);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CalendarDay>>> getCalendarSummary(
      DateTime month) async {
    try {
      final monthStart = DateTime(month.year, month.month);
      final monthEnd = DateTime(month.year, month.month + 1);
      final rows =
          await _dataSource.getTransactionsInRange(monthStart, monthEnd);

      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final totals = List<double>.filled(daysInMonth, 0);
      for (final r in rows) {
        final entity = r.toEntity();
        if (entity.type != TransactionType.expense) continue;
        totals[entity.date.day - 1] += entity.amount;
      }
      final days = List.generate(
          daysInMonth, (i) => CalendarDay(day: i + 1, amount: totals[i]));
      return Right(days);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReportSummary>> getReportSummary(
      ReportPeriod period) async {
    try {
      final now = DateTime.now();
      final (start, end) = switch (period) {
        ReportPeriod.week => (
            now.subtract(const Duration(days: 6)),
            now.add(const Duration(days: 1))
          ),
        ReportPeriod.month => (
            DateTime(now.year, now.month),
            DateTime(now.year, now.month + 1)
          ),
        ReportPeriod.year => (DateTime(now.year), DateTime(now.year + 1)),
      };

      final transactions =
          (await _dataSource.getTransactionsInRange(start, end))
              .map((r) => r.toEntity())
              .toList();
      final expenses =
          transactions.where((t) => t.type == TransactionType.expense).toList();
      final totalIncome = transactions
          .where((t) => t.type == TransactionType.income)
          .fold<double>(0, (s, t) => s + t.amount);
      final totalExpense = expenses.fold<double>(0, (s, t) => s + t.amount);

      final breakdown = _categoryBreakdown(expenses, totalExpense);
      final topCategoryGroup = breakdown.isEmpty ? null : breakdown.first.group;

      final daySpan = end.difference(start).inDays.clamp(1, 366);
      final avgPerDay = totalExpense / daySpan;

      final byDay = <String, double>{};
      for (final t in expenses) {
        final key = DateFormat('yyyy-MM-dd').format(t.date);
        byDay[key] = (byDay[key] ?? 0) + t.amount;
      }
      final maxSpendDay = byDay.values.fold<double>(0, (m, v) => v > m ? v : m);

      final savingsRatePercent = totalIncome == 0
          ? 0.0
          : (totalIncome - totalExpense) / totalIncome * 100;

      final weekBars = _weeklyBars(expenses, start, end);

      return Right(ReportSummary(
        topCategoryGroup: topCategoryGroup,
        avgPerDay: avgPerDay,
        maxSpendDay: maxSpendDay,
        savingsRatePercent: double.parse(savingsRatePercent.toStringAsFixed(1)),
        categoryBreakdown: breakdown,
        weekBars: weekBars,
      ));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsForDay(
      DateTime day) async {
    try {
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final rows = await _dataSource.getTransactionsInRange(dayStart, dayEnd);
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTransaction(
      Transaction transaction) async {
    try {
      await _dataSource
          .updateTransaction(TransactionModel.fromEntity(transaction));
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    try {
      await _dataSource.deleteTransaction(id);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getYearToDateSavings(int year) async {
    try {
      final start = DateTime(year);
      final now = DateTime.now();
      final end = now.add(const Duration(days: 1));
      final rows = await _dataSource.getTransactionsInRange(start, end);

      var savings = 0.0;
      for (final row in rows) {
        final entity = row.toEntity();
        savings += entity.type == TransactionType.income
            ? entity.amount
            : -entity.amount;
      }
      return Right(savings);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  List<CategoryShare> _categoryBreakdown(
      List<Transaction> expenses, double totalExpense) {
    final byGroup = <ChartCategoryGroup, double>{};
    for (final t in expenses) {
      final group = t.expenseCategory!.chartGroup;
      byGroup[group] = (byGroup[group] ?? 0) + t.amount;
    }
    return byGroup.entries
        .map((e) => CategoryShare(
              group: e.key,
              percent: totalExpense == 0 ? 0 : (e.value / totalExpense) * 100,
            ))
        .toList()
      ..sort((a, b) => b.percent.compareTo(a.percent));
  }

  /// Splits [start, end) into 4 equal buckets labeled T1-T4, summing expense
  /// amounts per bucket — used for the Reports weekly bar chart regardless
  /// of the selected period's actual span.
  List<WeekBar> _weeklyBars(
      List<Transaction> expenses, DateTime start, DateTime end) {
    final totalSpan = end.difference(start);
    final bucketSpan = Duration(microseconds: totalSpan.inMicroseconds ~/ 4);
    final sums = List<double>.filled(4, 0);

    for (final t in expenses) {
      final offset = t.date.difference(start);
      if (offset.isNegative) continue;
      final bucketIndex =
          (offset.inMicroseconds ~/ bucketSpan.inMicroseconds).clamp(0, 3);
      sums[bucketIndex] += t.amount;
    }

    final maxSum = sums.fold<double>(0, (m, v) => v > m ? v : m);
    return [
      for (var i = 0; i < 4; i++)
        WeekBar(
            label: 'T${i + 1}',
            percent: maxSum == 0 ? 0 : (sums[i] / maxSum) * 100),
    ];
  }
}
