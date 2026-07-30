import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:spendly_app/features/category_management/data/datasources/category_remote_datasource.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/data/category_breakdown_utils.dart';
import 'package:spendly_app/features/transactions/domain/entities/calendar_day.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_summary.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:spendly_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/data/models/transaction_model.dart';

class TransactionRepository implements ITransactionRepository {
  const TransactionRepository(
      this._dataSource, this._budgetDataSource, this._categoryDataSource);

  final TransactionRemoteDataSource _dataSource;
  final BudgetRemoteDataSource _budgetDataSource;
  final CategoryRemoteDataSource _categoryDataSource;

  Future<Map<String, Category>> _categoryMap() async {
    final categories = await _categoryDataSource.getCategories();
    return {for (final c in categories) c.id: c.toEntity()};
  }

  Future<List<Transaction>> _resolve(
      List<TransactionModel> rows, Map<String, Category> categoryMap) async {
    return rows
        .map((r) =>
            r.toEntity(r.categoryId == null ? null : categoryMap[r.categoryId]))
        .toList();
  }

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary(
      DateTime month) async {
    try {
      final monthStart = DateTime(month.year, month.month);
      final monthEnd = DateTime(month.year, month.month + 1);
      final categoryMap = await _categoryMap();
      final transactions = await _resolve(
          await _dataSource.getTransactionsInRange(monthStart, monthEnd),
          categoryMap);

      final income =
          transactions.where((t) => t.type == TransactionType.income);
      final expenses =
          transactions.where((t) => t.type == TransactionType.expense).toList();
      final totalIncome = income.fold<double>(0, (sum, t) => sum + t.amount);
      final totalExpense = expenses.fold<double>(0, (sum, t) => sum + t.amount);

      final breakdown = _breakdownFor(expenses, totalExpense);

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
      final budgetedCategoryIds = budgetRows.map((r) => r.categoryId).toSet();
      final budgetTotal =
          budgetRows.fold<double>(0, (sum, r) => sum + r.budgetAmount);
      final budgetUsed = expenses
          .where((t) =>
              t.category != null &&
              budgetedCategoryIds.contains(t.category!.id))
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
      return Right(saved.toEntity(transaction.category));
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
      final categoryMap = await _categoryMap();
      var transactions =
          await _resolve(await _dataSource.getAllTransactions(), categoryMap);

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
        if (r.type != TransactionType.expense) continue;
        totals[r.date.day - 1] += r.amount;
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

      final categoryMap = await _categoryMap();
      final transactions = await _resolve(
          await _dataSource.getTransactionsInRange(start, end), categoryMap);
      final expenses =
          transactions.where((t) => t.type == TransactionType.expense).toList();
      final totalIncome = transactions
          .where((t) => t.type == TransactionType.income)
          .fold<double>(0, (s, t) => s + t.amount);
      final totalExpense = expenses.fold<double>(0, (s, t) => s + t.amount);

      final breakdown = _breakdownFor(expenses, totalExpense);
      final topCategory = breakdown.isEmpty ? null : breakdown.first;

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
        topCategory: topCategory,
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
      final categoryMap = await _categoryMap();
      final rows = await _dataSource.getTransactionsInRange(dayStart, dayEnd);
      return Right(await _resolve(rows, categoryMap));
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

  List<CategoryShare> _breakdownFor(
      List<Transaction> expenses, double totalExpense) {
    final byCategory = <String, double>{};
    final categoryById = <String, Category>{};
    for (final t in expenses) {
      final category = t.category;
      if (category == null) continue;
      byCategory[category.id] = (byCategory[category.id] ?? 0) + t.amount;
      categoryById[category.id] = category;
    }
    return foldCategoryBreakdown(byCategory, categoryById, totalExpense);
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
