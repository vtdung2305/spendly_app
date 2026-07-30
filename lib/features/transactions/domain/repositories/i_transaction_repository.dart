import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/entities/calendar_day.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_summary.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

abstract class ITransactionRepository {
  Future<Either<Failure, DashboardSummary>> getDashboardSummary(DateTime month);

  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction);

  /// Full transaction history, optionally filtered by type and/or a
  /// case-insensitive label search — used by Transaction History and
  /// Income Management.
  Future<Either<Failure, List<Transaction>>> getTransactions({
    TransactionType? type,
    String? searchQuery,
  });

  Future<Either<Failure, List<CalendarDay>>> getCalendarSummary(DateTime month);

  Future<Either<Failure, ReportSummary>> getReportSummary(ReportPeriod period);

  /// All transactions on a single calendar [day] — used by the Calendar
  /// day-detail sheet's tap-to-edit/delete list.
  Future<Either<Failure, List<Transaction>>> getTransactionsForDay(
      DateTime day);

  Future<Either<Failure, Unit>> updateTransaction(Transaction transaction);

  Future<Either<Failure, Unit>> deleteTransaction(String id);
}
