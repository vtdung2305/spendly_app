import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/domain/usecases/get_transactions_usecase.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._getTransactionsUseCase) : super(const HistoryLoading());

  final GetTransactionsUseCase _getTransactionsUseCase;

  Future<void> load({String searchQuery = ''}) async {
    emit(const HistoryLoading());
    final result = await _getTransactionsUseCase(
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
    );
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (transactions) => emit(HistoryLoaded(transactions, searchQuery: searchQuery)),
    );
  }
}
