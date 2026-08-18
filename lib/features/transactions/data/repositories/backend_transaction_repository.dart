import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/core/network/backend_error_mapper.dart';
import 'package:spendly_app/core/utils/num_parsing.dart';
import 'package:spendly_app/features/category_management/data/datasources/backend_category_remote_datasource.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/data/category_breakdown_utils.dart';
import 'package:spendly_app/features/transactions/data/datasources/backend_transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/data/models/transaction_model.dart';
import 'package:spendly_app/features/transactions/domain/entities/calendar_day.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_summary.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class BackendTransactionRepository implements ITransactionRepository {
  const BackendTransactionRepository(
      this._dataSource, this._categoryDataSource);

  final BackendTransactionRemoteDataSource _dataSource;
  final BackendCategoryRemoteDataSource _categoryDataSource;

  Future<Map<String, Category>> _categoryMap() async {
    final categories = await _categoryDataSource.getCategories();
    return {for (final c in categories) c.id: c.toEntity()};
  }

  String _dateOnly(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary(
      DateTime month) async {
    try {
      final json = await _dataSource.getDashboardSummary(month);
      final categoryMap = await _categoryMap();

      final budget = json['budget'] as Map<String, dynamic>? ?? const {};
      final categoryBreakdown = _breakdownFromJson(
          json['categoryBreakdown'] as List<dynamic>? ?? const [], categoryMap);

      final dailySpendAll =
          (json['dailySpend'] as List<dynamic>? ?? const []).map((r) {
        final row = r as Map<String, dynamic>;
        return DailySpendPoint(
          day: DateTime.parse(row['date'] as String).day,
          total: parseNum(row['total']),
        );
      }).toList();
      // Mirrors Supabase-mode's rolling 14-day window ending today for the bar chart.
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final now = DateTime.now();
      final isCurrentMonth = month.year == now.year && month.month == now.month;
      final lastBarDay = isCurrentMonth ? now.day : daysInMonth;
      final firstBarDay = (lastBarDay - 13).clamp(1, daysInMonth);
      final dailySpend = dailySpendAll
          .where((p) => p.day >= firstBarDay && p.day <= lastBarDay)
          .toList();

      final recentTransactions =
          (json['recentTransactions'] as List<dynamic>? ?? const []).map((r) {
        final model =
            TransactionModel.fromBackendJson(r as Map<String, dynamic>);
        return model.toEntity(model.embeddedCategory);
      }).toList();

      return Right(DashboardSummary(
        monthLabel: 'Tháng ${month.month}, ${month.year}',
        totalIncome: parseNum(json['income']),
        totalExpense: parseNum(json['expense']),
        budgetTotal: parseNum(budget['totalLimit']),
        budgetUsed: parseNum(budget['totalSpent']),
        categoryBreakdown: categoryBreakdown,
        dailySpend: dailySpend,
        recentTransactions: recentTransactions,
      ));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Transaction>> addTransaction(
      Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final saved = await _dataSource.addTransaction(model);
      return Right(
          saved.toEntity(saved.embeddedCategory ?? transaction.category));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({
    TransactionType? type,
    String? searchQuery,
    DateTime? dateFrom,
    DateTime? dateTo,
    double? minAmount,
    String? categoryId,
  }) async {
    try {
      final models = await _dataSource.getTransactions(
        type: type,
        search:
            searchQuery?.trim().isEmpty ?? true ? null : searchQuery!.trim(),
        dateFrom: dateFrom == null ? null : _dateOnly(dateFrom),
        dateTo: dateTo == null ? null : _dateOnly(dateTo),
      );
      var transactions =
          models.map((m) => m.toEntity(m.embeddedCategory)).toList();
      if (minAmount != null) {
        transactions =
            transactions.where((t) => t.amount >= minAmount).toList();
      }
      if (categoryId != null) {
        transactions =
            transactions.where((t) => t.category?.id == categoryId).toList();
      }
      return Right(transactions);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, List<CalendarDay>>> getCalendarSummary(
      DateTime month) async {
    try {
      return Right(await _dataSource.getDailySummary(month));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, ReportSummary>> getReportSummary(
      ReportPeriod period) async {
    try {
      final now = DateTime.now();
      final previousDate = switch (period) {
        ReportPeriod.week => now.subtract(const Duration(days: 7)),
        ReportPeriod.month => DateTime(now.year, now.month - 1, now.day),
        ReportPeriod.year => DateTime(now.year - 1, now.month, now.day),
      };

      final json = await _dataSource.getPeriodSummary(
          period.name, _dateOnly(now));
      final previousJson = await _dataSource.getPeriodSummary(
          period.name, _dateOnly(previousDate));
      final categoryMap = await _categoryMap();

      final categoryBreakdown = _breakdownFromJson(
          json['categoryBreakdown'] as List<dynamic>? ?? const [], categoryMap);

      final topCategoryJson = json['topCategory'] as Map<String, dynamic>?;
      final topCategory = topCategoryJson == null
          ? null
          : CategoryShare(
              category: categoryMap[topCategoryJson['categoryId']],
              amount: parseNum(topCategoryJson['amount']),
              percent: parseNum(topCategoryJson['percent']),
            );

      final highestSpendDay = json['highestSpendDay'] as Map<String, dynamic>?;
      final chart = json['chart'] as Map<String, dynamic>? ?? const {};
      final labels =
          (chart['labels'] as List<dynamic>? ?? const []).cast<String>();
      final values = (chart['values'] as List<dynamic>? ?? const [])
          .map((v) => parseNum(v))
          .toList();
      final maxValue = values.fold<double>(0, (m, v) => v > m ? v : m);
      final chartBars = [
        for (var i = 0; i < labels.length; i++)
          ChartBar(
            label: labels[i],
            percent: maxValue == 0 ? 0 : (values[i] / maxValue) * 100,
          ),
      ];

      final totalIncome = parseNum(json['income']);
      final totalExpense = parseNum(json['expense']);
      final previousIncome = parseNum(previousJson['income']);
      final previousExpense = parseNum(previousJson['expense']);

      return Right(ReportSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        incomeDeltaPercent: _deltaPercent(totalIncome, previousIncome),
        expenseDeltaPercent: _deltaPercent(totalExpense, previousExpense),
        topCategory: topCategory,
        avgPerDay: parseNum(json['avgPerDay']),
        maxSpendDay: parseNum(highestSpendDay?['total']),
        savingsRatePercent:
            double.parse(parseNum(json['savingsRate']).toStringAsFixed(1)),
        categoryBreakdown: categoryBreakdown,
        chartBars: chartBars,
      ));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  double? _deltaPercent(double current, double previous) {
    if (previous == 0) return null;
    return double.parse(
        ((current - previous) / previous * 100).toStringAsFixed(1));
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsForDay(
      DateTime day) async {
    try {
      final dateStr = _dateOnly(day);
      final models =
          await _dataSource.getTransactions(dateFrom: dateStr, dateTo: dateStr);
      return Right(models.map((m) => m.toEntity(m.embeddedCategory)).toList());
    } catch (e) {
      return Left(mapBackendError(e));
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
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    try {
      await _dataSource.deleteTransaction(id);
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  List<CategoryShare> _breakdownFromJson(
      List<dynamic> rows, Map<String, Category> categoryMap) {
    final amountByCategoryId = <String, double>{};
    for (final r in rows) {
      final row = r as Map<String, dynamic>;
      final categoryId = row['categoryId'] as String;
      amountByCategoryId[categoryId] = parseNum(row['amount']);
    }
    final totalExpense =
        amountByCategoryId.values.fold<double>(0, (sum, v) => sum + v);
    return foldCategoryBreakdown(amountByCategoryId, categoryMap, totalExpense);
  }
}
