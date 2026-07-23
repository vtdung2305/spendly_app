import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/report_period.dart';
import '../entities/report_summary.dart';
import '../repositories/i_transaction_repository.dart';

class GetReportSummaryUseCase {
  const GetReportSummaryUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, ReportSummary>> call(ReportPeriod period) =>
      _repository.getReportSummary(period);
}
