import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';

sealed class RecurringTransactionListState {
  const RecurringTransactionListState();
}

class RecurringTransactionListLoading extends RecurringTransactionListState {
  const RecurringTransactionListLoading();
}

class RecurringTransactionListLoaded extends RecurringTransactionListState {
  const RecurringTransactionListLoaded(this.items);
  final List<RecurringTransaction> items;
}

class RecurringTransactionListError extends RecurringTransactionListState {
  const RecurringTransactionListError(this.message);
  final String message;
}
