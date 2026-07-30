import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';

abstract class ICategoryRepository {
  /// No [type] filter returns both expense and income categories.
  Future<Either<Failure, List<Category>>> getCategories({CategoryType? type});

  Future<Either<Failure, Unit>> addCategory(
      String label, String iconName, String colorHex, CategoryType type);

  Future<Either<Failure, Unit>> updateCategory(Category category);

  Future<Either<Failure, Unit>> deleteCategory(String id);
}
