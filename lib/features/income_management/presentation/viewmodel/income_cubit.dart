import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/usecases/get_transactions_usecase.dart';
import 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit(this._getTransactionsUseCase) : super(const IncomeLoading());

  final GetTransactionsUseCase _getTransactionsUseCase;

  Future<void> load() async {
    emit(const IncomeLoading());
    final result = await _getTransactionsUseCase(type: TransactionType.income);
    result.fold(
      (failure) => emit(IncomeError(failure.message)),
      (transactions) => emit(IncomeLoaded(transactions)),
    );
  }
}
