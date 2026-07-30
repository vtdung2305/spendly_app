import 'package:spendly_app/features/category_management/domain/entities/category.dart';

/// DTO for a `public.categories` row. Kept separate from [Category] so JSON
/// shape can change without touching domain/presentation.
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.label,
    required this.iconName,
    required this.colorHex,
    required this.type,
    this.isDefault = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as String,
        label: json['label'] as String,
        iconName: json['icon'] as String,
        colorHex: json['color'] as String,
        type: (json['type'] as String?) == 'income'
            ? CategoryType.income
            : CategoryType.expense,
        isDefault: json['is_default'] as bool? ?? false,
      );

  /// Maps the custom backend's `/api/v1/categories` shape — `name`/`icon`/
  /// `color`/`type`/`isDefault` (camelCase, `type` upper-cased
  /// `EXPENSE`/`INCOME`), as opposed to Supabase's `label`/`icon`/`color`/
  /// `type`/`is_default` (snake_case, lower-cased `type`).
  factory CategoryModel.fromBackendJson(Map<String, dynamic> json) =>
      CategoryModel(
        id: json['id'] as String,
        label: json['name'] as String,
        iconName: json['icon'] as String,
        colorHex: json['color'] as String,
        type: (json['type'] as String?) == 'INCOME'
            ? CategoryType.income
            : CategoryType.expense,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  final String id;
  final String label;
  final String iconName;
  final String colorHex;
  final CategoryType type;
  final bool isDefault;

  Category toEntity() => Category(
        id: id,
        label: label,
        iconName: iconName,
        colorHex: colorHex,
        type: type,
        isDefault: isDefault,
      );
}
