import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._getTransactionsUseCase, this._deleteTransactionUseCase)
      : super(const HistoryLoading());

  final GetTransactionsUseCase _getTransactionsUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  Future<void> load({String searchQuery = ''}) async {
    emit(const HistoryLoading());
    final result = await _getTransactionsUseCase(
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
    );
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (transactions) =>
          emit(HistoryLoaded(transactions, searchQuery: searchQuery)),
    );
  }

  /// Returns an error message on failure, or null on success — reloads the
  /// list (keeping the current search query) either way.
  Future<String?> delete(String id) async {
    final searchQuery =
        state is HistoryLoaded ? (state as HistoryLoaded).searchQuery : '';
    final result = await _deleteTransactionUseCase(id);
    await load(searchQuery: searchQuery);
    return result.fold((failure) => failure.message, (_) => null);
  }
}
