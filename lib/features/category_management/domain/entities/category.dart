import 'package:equatable/equatable.dart';

/// EXPENSE vs INCOME — mirrors the custom backend's `CategoryType` enum.
/// Immutable per category (can't be changed after creation, matching the
/// backend's PATCH not allowing type changes).
enum CategoryType { expense, income }

/// A user-customizable category — replaces the old fixed `ExpenseCategory`/
/// `IncomeSource` enums app-wide (Add Transaction, Budget, Dashboard,
/// Reports, Calendar, History all read from this now, not a hardcoded list).
class Category extends Equatable {
  const Category({
    required this.id,
    required this.label,
    required this.iconName,
    required this.colorHex,
    required this.type,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String iconName;
  final String colorHex;
  final CategoryType type;

  /// True only for the backend's (or Supabase's seeded-default) undeletable
  /// "Khác" category of each type — can't be deleted (the UI hides the
  /// delete button; the repository also rejects the request).
  final bool isDefault;

  Category copyWith({String? label, String? iconName, String? colorHex}) {
    return Category(
      id: id,
      label: label ?? this.label,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      type: type,
      isDefault: isDefault,
    );
  }

  @override
  List<Object?> get props => [id, label, iconName, colorHex, type, isDefault];
}
