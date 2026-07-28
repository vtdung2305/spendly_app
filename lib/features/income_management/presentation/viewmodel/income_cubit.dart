import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit(this._getTransactionsUseCase, this._deleteTransactionUseCase)
      : super(const IncomeLoading());

  final GetTransactionsUseCase _getTransactionsUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  Future<void> load() async {
    emit(const IncomeLoading());
    final result = await _getTransactionsUseCase(type: TransactionType.income);
    result.fold(
      (failure) => emit(IncomeError(failure.message)),
      (transactions) => emit(IncomeLoaded(transactions)),
    );
  }

  /// Returns an error message on failure, or null on success — reloads the
  /// list either way.
  Future<String?> delete(String id) async {
    final result = await _deleteTransactionUseCase(id);
    await load();
    return result.fold((failure) => failure.message, (_) => null);
  }
}
