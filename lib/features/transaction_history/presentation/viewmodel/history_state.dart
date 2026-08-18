import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'history_filter.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded(
    this.transactions, {
    this.searchQuery = '',
    this.filter = HistoryFilter.empty,
    this.categories = const [],
  });
  final List<Transaction> transactions;
  final String searchQuery;
  final HistoryFilter filter;
  final List<Category> categories;

  @override
  List<Object?> get props => [transactions, searchQuery, filter, categories];
}

class HistoryError extends HistoryState {
  const HistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
