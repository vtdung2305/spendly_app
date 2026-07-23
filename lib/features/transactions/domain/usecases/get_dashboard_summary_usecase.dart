import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/i_transaction_repository.dart';

class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, DashboardSummary>> call(DateTime month) =>
      _repository.getDashboardSummary(month);
}
