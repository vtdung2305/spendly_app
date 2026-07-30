import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spendly_app/features/category_management/data/models/category_model.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';

/// Thrown when trying to delete a category with [Category.isDefault] — the
/// undeletable "Khác" row of each type. Defense-in-depth: the UI already
/// hides the delete button for these.
class DefaultCategoryDeleteException implements Exception {
  const DefaultCategoryDeleteException();
}

class CategoryRemoteDataSource {
  CategoryRemoteDataSource(this._client);

  final SupabaseClient _client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const AuthException('Chưa đăng nhập');
    return id;
  }

  Future<List<CategoryModel>> getCategories({CategoryType? type}) async {
    var query = _client.from('categories').select().eq('user_id', _userId);
    if (type != null) query = query.eq('type', type.name);
    final rows = await query.order('created_at');
    return (rows as List)
        .map((r) => CategoryModel.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCategory(
      String label, String iconName, String colorHex, CategoryType type) async {
    await _client.from('categories').insert({
      'user_id': _userId,
      'label': label,
      'icon': iconName,
      'color': colorHex,
      'type': type.name,
    });
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _client
        .from('categories')
        .update({
          'label': category.label,
          'icon': category.iconName,
          'color': category.colorHex,
        })
        .eq('id', category.id)
        .eq('user_id', _userId);
  }

  /// Reassigns any transactions/budgets pointing at this category to the
  /// user's "Khác" default of the same type before deleting it — mirrors the
  /// custom backend's documented delete behavior, so both data sources agree.
  Future<void> deleteCategory(String id) async {
    final row = await _client
        .from('categories')
        .select()
        .eq('id', id)
        .eq('user_id', _userId)
        .single();
    final category = CategoryModel.fromJson(row);
    if (category.isDefault) throw const DefaultCategoryDeleteException();

    final fallback = await _client
        .from('categories')
        .select()
        .eq('user_id', _userId)
        .eq('type', category.type.name)
        .eq('is_default', true)
        .maybeSingle();

    if (fallback != null) {
      await _client
          .from('transactions')
          .update({'category_id': fallback['id']})
          .eq('category_id', id)
          .eq('user_id', _userId);
    }
    await _client
        .from('budgets')
        .delete()
        .eq('category_id', id)
        .eq('user_id', _userId);
    await _client
        .from('categories')
        .delete()
        .eq('id', id)
        .eq('user_id', _userId);
  }
}
