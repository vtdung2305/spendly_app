import 'package:equatable/equatable.dart';

/// Form state for the Edit Budget screen (9c) — category & used amount are
/// read-only (fixed at construction), only the monthly limit is editable.
class EditBudgetState extends Equatable {
  const EditBudgetState({
    this.amount = 0,
    this.isSaving = false,
    this.saved = false,
    this.deleted = false,
    this.errorMessage,
  });

  final double amount;
  final bool isSaving;
  final bool saved;
  final bool deleted;
  final String? errorMessage;

  bool get isValid => amount > 0;

  EditBudgetState copyWith({
    double? amount,
    bool? isSaving,
    bool? saved,
    bool? deleted,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return EditBudgetState(
      amount: amount ?? this.amount,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      deleted: deleted ?? this.deleted,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [amount, isSaving, saved, deleted, errorMessage];
}
