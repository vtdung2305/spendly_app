import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/category_management/domain/repositories/i_category_repository.dart';

class DeleteCategoryUseCase {
  const DeleteCategoryUseCase(this._repository);

  final ICategoryRepository _repository;

  Future<Either<Failure, Unit>> call(String id) =>
      _repository.deleteCategory(id);
}
