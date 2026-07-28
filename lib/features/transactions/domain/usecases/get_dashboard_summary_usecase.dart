import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/entities/dashboard_summary.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, DashboardSummary>> call(DateTime month) =>
      _repository.getDashboardSummary(month);
}
