/// Form state for the Create/Edit Savings Goal screen (4c) — `name`,
/// `targetAmount`, `deadline`, and `initialAmount` ("Đã tiết kiệm",
/// optional) all map to real backend fields (`/api/v1/savings-goals`).
class SavingsGoalFormState {
  const SavingsGoalFormState({
    this.name = '',
    this.targetAmount = 0,
    this.initialAmount = 0,
    required this.deadline,
    this.isSaving = false,
    this.saved = false,
    this.deleted = false,
    this.errorMessage,
  });

  final String name;
  final double targetAmount;
  final double initialAmount;
  final DateTime deadline;
  final bool isSaving;
  final bool saved;
  final bool deleted;
  final String? errorMessage;

  bool get isValid => name.trim().isNotEmpty && targetAmount > 0;

  SavingsGoalFormState copyWith({
    String? name,
    double? targetAmount,
    double? initialAmount,
    DateTime? deadline,
    bool? isSaving,
    bool? saved,
    bool? deleted,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SavingsGoalFormState(
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      initialAmount: initialAmount ?? this.initialAmount,
      deadline: deadline ?? this.deadline,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      deleted: deleted ?? this.deleted,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
