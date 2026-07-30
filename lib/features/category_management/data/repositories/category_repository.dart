import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/category_management/data/datasources/category_remote_datasource.dart';
import 'package:spendly_app/features/category_management/data/models/category_model.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/domain/repositories/i_category_repository.dart';

class CategoryRepository implements ICategoryRepository {
  const CategoryRepository(this._dataSource);

  final CategoryRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<Category>>> getCategories(
      {CategoryType? type}) async {
    try {
      final models = await _dataSource.getCategories(type: type);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addCategory(
      String label, String iconName, String colorHex, CategoryType type) async {
    try {
      await _dataSource.addCategory(label, iconName, colorHex, type);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCategory(Category category) async {
    try {
      await _dataSource.updateCategory(CategoryModel(
        id: category.id,
        label: category.label,
        iconName: category.iconName,
        colorHex: category.colorHex,
        type: category.type,
        isDefault: category.isDefault,
      ));
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      await _dataSource.deleteCategory(id);
      return const Right(unit);
    } on DefaultCategoryDeleteException {
      return const Left(
          ValidationFailure('Không thể xóa danh mục mặc định "Khác"'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
