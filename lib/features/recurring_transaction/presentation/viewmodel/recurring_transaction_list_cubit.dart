import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/recurring_transaction/domain/usecases/get_recurring_transactions_usecase.dart';
import 'recurring_transaction_list_state.dart';

class RecurringTransactionListCubit extends Cubit<RecurringTransactionListState> {
  RecurringTransactionListCubit(this._getRecurringTransactionsUseCase)
      : super(const RecurringTransactionListLoading());

  final GetRecurringTransactionsUseCase _getRecurringTransactionsUseCase;

  Future<void> load() async {
    emit(const RecurringTransactionListLoading());
    final result = await _getRecurringTransactionsUseCase();
    result.fold(
      (failure) => emit(RecurringTransactionListError(failure.message)),
      (items) => emit(RecurringTransactionListLoaded(items)),
    );
  }
}
