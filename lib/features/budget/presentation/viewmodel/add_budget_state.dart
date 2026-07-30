import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';

/// Form state for the Add Budget screen. Save button is enabled only once
/// [isValid] — category set AND amount > 0, per design.
class AddBudgetState extends Equatable {
  const AddBudgetState({
    this.category,
    this.amount = 0,
    this.categories = const [],
    this.isSaving = false,
    this.saved = false,
    this.errorMessage,
  });

  final Category? category;
  final double amount;
  final List<Category> categories;
  final bool isSaving;
  final bool saved;
  final String? errorMessage;

  bool get isValid => category != null && amount > 0;

  AddBudgetState copyWith({
    Category? category,
    double? amount,
    List<Category>? categories,
    bool? isSaving,
    bool? saved,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AddBudgetState(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      categories: categories ?? this.categories,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [category, amount, categories, isSaving, saved, errorMessage];
}
