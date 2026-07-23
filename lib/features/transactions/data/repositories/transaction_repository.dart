import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/calendar_day.dart';
import '../../domain/entities/chart_category_group.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/report_period.dart';
import '../../domain/entities/report_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../datasources/transaction_mock_datasource.dart';
import '../datasources/transaction_seed_data.dart';
import '../models/transaction_model.dart';

class TransactionRepository implements ITransactionRepository {
  const TransactionRepository(this._dataSource);
  final TransactionMockDataSource _dataSource;

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary(DateTime month) async {
    try {
      final rows = await _dataSource.getTransactionsForMonth(month);
      final transactions = rows.map((r) => r.toEntity()).toList();

      final income = transactions.where((t) => t.type == TransactionType.income);
      final expenses = transactions.where((t) => t.type == TransactionType.expense);
      final totalIncome = income.fold<double>(0, (sum, t) => sum + t.amount);
      final totalExpense = expenses.fold<double>(0, (sum, t) => sum + t.amount);

      final byGroup = <ChartCategoryGroup, double>{};
      for (final t in expenses) {
        final group = t.expenseCategory!.chartGroup;
        byGroup[group] = (byGroup[group] ?? 0) + t.amount;
      }
      final breakdown = byGroup.entries
          .map((e) => CategoryShare(
                group: e.key,
                percent: totalExpense == 0 ? 0 : (e.value / totalExpense) * 100,
              ))
          .toList()
        ..sort((a, b) => b.percent.compareTo(a.percent));

      final dailySpend = TransactionSeedData.dailySpend14Days()
          .asMap()
          .entries
          .map((e) => DailySpendPoint(day: e.key + 1, total: e.value))
          .toList();

      final recent = [...transactions]..sort((a, b) => b.date.compareTo(a.date));

      return Right(DashboardSummary(
        monthLabel: 'Tháng ${month.month}, ${month.year}',
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        budgetTotal: _dataSource.budgetTotal,
        budgetUsed: _dataSource.budgetUsed,
        categoryBreakdown: breakdown,
        dailySpend: dailySpend,
        recentTransactions: recent.take(10).toList(),
      ));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction) async {
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
      // Income Management uses its own curated dataset per design handoff
      // (month chips there are decorative, not real filters).
      final rows = type == TransactionType.income
          ? await _dataSource.getIncomeList()
          : await _dataSource.getHistoryPool();
      var transactions = rows.map((r) => r.toEntity()).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      if (type != null) {
        transactions = transactions.where((t) => t.type == type).toList();
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        transactions = transactions
            .where((t) => (t.note ?? t.displayLabel).toLowerCase().contains(query))
            .toList();
      }
      return Right(transactions);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CalendarDay>>> getCalendarSummary(DateTime month) async {
    try {
      final amounts = await _dataSource.getCalendarAmounts();
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final days = List.generate(
        daysInMonth,
        (i) => CalendarDay(day: i + 1, amount: i < amounts.length ? amounts[i] : 0),
      );
      return Right(days);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReportSummary>> getReportSummary(ReportPeriod period) async {
    try {
      // Static per design handoff — the Tuần/Tháng/Năm tabs only change the
      // active tab highlight, not the underlying mock numbers.
      final breakdown = TransactionSeedData.seed()
          .where((t) => t.type == TransactionType.expense)
          .fold<Map<ChartCategoryGroup, double>>({}, (map, t) {
            final group = t.expenseCategory!.chartGroup;
            map[group] = (map[group] ?? 0) + t.amount;
            return map;
          });
      final totalExpense = breakdown.values.fold<double>(0, (a, b) => a + b);
      final categoryBreakdown = breakdown.entries
          .map((e) => CategoryShare(
                group: e.key,
                percent: totalExpense == 0 ? 0 : (e.value / totalExpense) * 100,
              ))
          .toList()
        ..sort((a, b) => b.percent.compareTo(a.percent));

      return Right(ReportSummary(
        topCategoryLabel: 'Ăn uống',
        avgPerDay: 596000,
        maxSpendDay: 1900000,
        savingsRatePercent: 58.9,
        categoryBreakdown: categoryBreakdown,
        weekBars: const [
          WeekBar(label: 'T1', percent: 55),
          WeekBar(label: 'T2', percent: 80),
          WeekBar(label: 'T3', percent: 40),
          WeekBar(label: 'T4', percent: 95),
        ],
      ));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
