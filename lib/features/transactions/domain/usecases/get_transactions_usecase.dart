import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class GetTransactionsUseCase {
  const GetTransactionsUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, List<Transaction>>> call({
    TransactionType? type,
    String? searchQuery,
  }) =>
      _repository.getTransactions(type: type, searchQuery: searchQuery);
}
