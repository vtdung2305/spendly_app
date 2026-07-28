import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class GetTransactionsForDayUseCase {
  const GetTransactionsForDayUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, List<Transaction>>> call(DateTime day) =>
      _repository.getTransactionsForDay(day);
}
