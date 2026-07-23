import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/calendar_day.dart';
import '../entities/dashboard_summary.dart';
import '../entities/report_period.dart';
import '../entities/report_summary.dart';
import '../entities/transaction.dart';

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
}
