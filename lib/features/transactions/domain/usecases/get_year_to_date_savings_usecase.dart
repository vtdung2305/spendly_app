import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class GetYearToDateSavingsUseCase {
  const GetYearToDateSavingsUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, double>> call(int year) =>
      _repository.getYearToDateSavings(year);
}
