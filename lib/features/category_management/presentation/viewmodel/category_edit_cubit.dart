import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/usecases/add_category_usecase.dart';
import 'package:spendly_app/features/category_management/domain/usecases/delete_category_usecase.dart';
import 'package:spendly_app/features/category_management/domain/usecases/get_categories_usecase.dart';
import 'package:spendly_app/features/category_management/domain/usecases/update_category_usecase.dart';
import 'category_edit_args.dart';
import 'category_edit_state.dart';

class CategoryEditCubit extends Cubit<CategoryEditState> {
  CategoryEditCubit(
    this._getCategoriesUseCase,
    this._addCategoryUseCase,
    this._updateCategoryUseCase,
    this._deleteCategoryUseCase,
    CategoryEditArgs args,
  ) : super(
          args.editing == null
              ? CategoryEditState(type: args.createType)
              : CategoryEditState(
                  id: args.editing!.id,
                  name: args.editing!.label,
                  iconName: args.editing!.iconName,
                  colorHex: args.editing!.colorHex,
                  type: args.editing!.type,
                  isDefault: args.editing!.isDefault,
                ),
        );

  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddCategoryUseCase _addCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  Future<void> loadExisting() async {
    final result = await _getCategoriesUseCase(type: state.type);
    result.fold((_) {}, (categories) {
      emit(state.copyWith(allCategories: categories));
    });
  }

  void setName(String name) {
    emit(state.copyWith(name: name, clearErrorMessage: true));
  }

  void setIcon(String iconName) {
    emit(state.copyWith(iconName: iconName));
  }

  void setColor(String colorHex) {
    emit(state.copyWith(colorHex: colorHex));
  }

  void setIconGroup(String iconGroup) {
    emit(state.copyWith(iconGroup: iconGroup));
  }

  Future<void> save() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = state.isEditing
        ? await _updateCategoryUseCase(Category(
            id: state.id!,
            label: state.trimmedName,
            iconName: state.iconName,
            colorHex: state.colorHex,
            type: state.type,
            isDefault: state.isDefault,
          ))
        : await _addCategoryUseCase(
            state.trimmedName, state.iconName, state.colorHex, state.type);

    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, saved: true)),
    );
  }

  Future<void> delete() async {
    if (!state.isEditing) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = await _deleteCategoryUseCase(state.id!);
    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, deleted: true)),
    );
  }
}
