import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/category_management/domain/entities/category.dart';

/// Form state for the Create/Edit Category screen (14b). [id] is null while
/// creating; set (and immutable) while editing an existing category.
class CategoryEditState extends Equatable {
  const CategoryEditState({
    this.id,
    this.name = '',
    this.iconName = 'restaurant',
    this.colorHex = '#4F46E5',
    this.iconGroup = 'food',
    this.type = CategoryType.expense,
    this.isDefault = false,
    this.allCategories = const [],
    this.isSaving = false,
    this.saved = false,
    this.deleted = false,
    this.errorMessage,
  });

  final String? id;
  final String name;
  final String iconName;
  final String colorHex;
  final String iconGroup;

  /// Fixed at construction — an existing category's own type when editing,
  /// or the caller-chosen type when creating (see [CategoryEditArgs]).
  final CategoryType type;

  /// True only when editing the undeletable "Khác" category — hides the
  /// delete button. Fixed at construction, never changes.
  final bool isDefault;

  /// Every existing category of [type] — used only to detect a duplicate
  /// [name] (case-insensitive, excluding this row itself while editing).
  final List<Category> allCategories;

  final bool isSaving;
  final bool saved;
  final bool deleted;
  final String? errorMessage;

  bool get isEditing => id != null;

  String get trimmedName => name.trim();

  bool get hasDuplicateName =>
      trimmedName.isNotEmpty &&
      allCategories.any((c) =>
          c.id != id && c.label.toLowerCase() == trimmedName.toLowerCase());

  bool get isValid => trimmedName.isNotEmpty && !hasDuplicateName;

  CategoryEditState copyWith({
    String? name,
    String? iconName,
    String? colorHex,
    String? iconGroup,
    List<Category>? allCategories,
    bool? isSaving,
    bool? saved,
    bool? deleted,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CategoryEditState(
      id: id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      iconGroup: iconGroup ?? this.iconGroup,
      type: type,
      isDefault: isDefault,
      allCategories: allCategories ?? this.allCategories,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      deleted: deleted ?? this.deleted,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        iconName,
        colorHex,
        iconGroup,
        type,
        isDefault,
        allCategories,
        isSaving,
        saved,
        deleted,
        errorMessage,
      ];
}
