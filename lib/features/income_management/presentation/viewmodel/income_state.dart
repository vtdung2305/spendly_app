import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/transaction.dart';

sealed class IncomeState extends Equatable {
  const IncomeState();

  @override
  List<Object?> get props => [];
}

class IncomeLoading extends IncomeState {
  const IncomeLoading();
}

class IncomeLoaded extends IncomeState {
  const IncomeLoaded(this.transactions);
  final List<Transaction> transactions;

  @override
  List<Object?> get props => [transactions];
}

class IncomeError extends IncomeState {
  const IncomeError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
