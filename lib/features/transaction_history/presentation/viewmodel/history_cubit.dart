import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/usecases/get_categories_usecase.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'history_filter.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._getTransactionsUseCase, this._deleteTransactionUseCase,
      this._getCategoriesUseCase)
      : super(const HistoryLoading());

  final GetTransactionsUseCase _getTransactionsUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  List<Category> _categories = const [];

  Future<void> load({
    String searchQuery = '',
    HistoryFilter filter = HistoryFilter.empty,
  }) async {
    emit(const HistoryLoading());
    if (_categories.isEmpty) {
      final categoriesResult = await _getCategoriesUseCase();
      _categories = categoriesResult.fold((_) => const [], (c) => c);
    }
    final result = await _getTransactionsUseCase(
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
      type: switch (filter.quickFilter) {
        HistoryQuickFilter.expenseOnly => TransactionType.expense,
        HistoryQuickFilter.incomeOnly => TransactionType.income,
        _ => null,
      },
      dateFrom: filter.dateFrom,
      dateTo: filter.dateTo,
      minAmount: filter.quickFilter == HistoryQuickFilter.over500k
          ? historyOver500kThreshold
          : null,
      categoryId: filter.categoryId,
    );
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (transactions) => emit(HistoryLoaded(transactions,
          searchQuery: searchQuery, filter: filter, categories: _categories)),
    );
  }

  /// Returns an error message on failure, or null on success — reloads the
  /// list (keeping the current search query and filter) either way.
  Future<String?> delete(String id) async {
    final current = state;
    final searchQuery = current is HistoryLoaded ? current.searchQuery : '';
    final filter = current is HistoryLoaded ? current.filter : HistoryFilter.empty;
    final result = await _deleteTransactionUseCase(id);
    await load(searchQuery: searchQuery, filter: filter);
    return result.fold((failure) => failure.message, (_) => null);
  }
}
