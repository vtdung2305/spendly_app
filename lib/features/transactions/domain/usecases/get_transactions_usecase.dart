import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/transaction.dart';
import '../repositories/i_transaction_repository.dart';

class GetTransactionsUseCase {
  const GetTransactionsUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, List<Transaction>>> call({
    TransactionType? type,
    String? searchQuery,
  }) =>
      _repository.getTransactions(type: type, searchQuery: searchQuery);
}
