import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/repositories/i_category_repository.dart';

class AddCategoryUseCase {
  const AddCategoryUseCase(this._repository);

  final ICategoryRepository _repository;

  Future<Either<Failure, Unit>> call(
          String label, String iconName, String colorHex, CategoryType type) =>
      _repository.addCategory(label, iconName, colorHex, type);
}
