import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.transactions, {this.searchQuery = ''});
  final List<Transaction> transactions;
  final String searchQuery;

  @override
  List<Object?> get props => [transactions, searchQuery];
}

class HistoryError extends HistoryState {
  const HistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
