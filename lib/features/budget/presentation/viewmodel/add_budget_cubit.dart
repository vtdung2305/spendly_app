import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/usecases/get_categories_usecase.dart';
import 'add_budget_state.dart';

class AddBudgetCubit extends Cubit<AddBudgetState> {
  AddBudgetCubit(this._getCategoriesUseCase, this._addBudgetUseCase)
      : super(const AddBudgetState());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddBudgetUseCase _addBudgetUseCase;

  Future<void> loadCategories() async {
    final result = await _getCategoriesUseCase(type: CategoryType.expense);
    result.fold((_) {}, (categories) {
      emit(state.copyWith(categories: categories));
    });
  }

  void selectCategory(Category category) {
    emit(state.copyWith(category: category));
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  Future<void> save() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = await _addBudgetUseCase(state.category!, state.amount);
    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, saved: true)),
    );
  }
}
