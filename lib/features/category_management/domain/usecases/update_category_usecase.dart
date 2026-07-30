import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/repositories/i_category_repository.dart';

class UpdateCategoryUseCase {
  const UpdateCategoryUseCase(this._repository);

  final ICategoryRepository _repository;

  Future<Either<Failure, Unit>> call(Category category) =>
      _repository.updateCategory(category);
}
