import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_summary.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class GetReportSummaryUseCase {
  const GetReportSummaryUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, ReportSummary>> call(ReportPeriod period) =>
      _repository.getReportSummary(period);
}
