/// Form state for the Create/Edit Savings Goal screen (4c). Only `year`
/// (create) and `targetAmount` are real, editable fields — the design
/// mock's "Tên mục tiêu"/"Đã tiết kiệm" have no backing API field, and
/// "Hạn hoàn thành" is always Dec 31 of [year] server-side, so neither is
/// part of this form.
class SavingsGoalFormState {
  const SavingsGoalFormState({
    this.year = 0,
    this.targetAmount = 0,
    this.isSaving = false,
    this.saved = false,
    this.errorMessage,
  });

  final int year;
  final double targetAmount;
  final bool isSaving;
  final bool saved;
  final String? errorMessage;

  bool get isValid => year > 0 && targetAmount > 0;

  SavingsGoalFormState copyWith({
    int? year,
    double? targetAmount,
    bool? isSaving,
    bool? saved,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SavingsGoalFormState(
      year: year ?? this.year,
      targetAmount: targetAmount ?? this.targetAmount,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
