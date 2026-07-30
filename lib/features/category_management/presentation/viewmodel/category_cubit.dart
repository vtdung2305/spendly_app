import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/usecases/get_categories_usecase.dart';
import 'category_state.dart';

/// Category Management stays expense-only, per the original design scope —
/// income categories are managed inline from Add Transaction's income tab.
class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._getCategoriesUseCase) : super(const CategoryLoading());

  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> load() async {
    emit(const CategoryLoading());
    final result = await _getCategoriesUseCase(type: CategoryType.expense);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}
