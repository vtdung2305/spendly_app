import 'package:spendly_app/features/category_management/domain/entities/category.dart';

/// Navigation args for `/categories/edit` — [editing] set means edit mode
/// (its own [Category.type] wins); otherwise a new category of [createType]
/// is created (Category Management's "+" defaults to expense; Add
/// Transaction's income-tab "+" passes [CategoryType.income]).
class CategoryEditArgs {
  const CategoryEditArgs(
      {this.editing, this.createType = CategoryType.expense});

  final Category? editing;
  final CategoryType createType;
}
