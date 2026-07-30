import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/features/category_management/data/models/category_model.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';

/// Custom backend's `/api/v1/categories`.
class BackendCategoryRemoteDataSource {
  BackendCategoryRemoteDataSource(this._client);

  final BackendApiClient _client;

  Future<List<CategoryModel>> getCategories({CategoryType? type}) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      'categories',
      queryParameters: type == null ? null : {'type': _typeName(type)},
    );
    final data =
        unwrapBackendData(response.data, statusCode: response.statusCode)
            as List<dynamic>;
    return data
        .map((r) => CategoryModel.fromBackendJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCategory(
      String label, String iconName, String colorHex, CategoryType type) async {
    await _client.dio.post('categories', data: {
      'name': label,
      'color': colorHex,
      'icon': iconName,
      'type': _typeName(type),
    });
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _client.dio.patch('categories/${category.id}', data: {
      'name': category.label,
      'color': category.colorHex,
      'icon': category.iconName,
    });
  }

  Future<void> deleteCategory(String id) async {
    await _client.dio.delete('categories/$id');
  }

  String _typeName(CategoryType type) =>
      type == CategoryType.income ? 'INCOME' : 'EXPENSE';
}
