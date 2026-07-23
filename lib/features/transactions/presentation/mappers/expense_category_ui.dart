import 'package:flutter/material.dart';

import '../../domain/entities/expense_category.dart';

/// Icon for each [ExpenseCategory] — kept out of domain since it depends on
/// Flutter.
extension ExpenseCategoryUi on ExpenseCategory {
  IconData get icon => switch (this) {
        ExpenseCategory.anUong => Icons.restaurant_rounded,
        ExpenseCategory.shopping => Icons.shopping_bag_rounded,
        ExpenseCategory.diLai => Icons.directions_car_rounded,
        ExpenseCategory.giaiTri => Icons.sports_esports_rounded,
        ExpenseCategory.yTe => Icons.medical_services_rounded,
        ExpenseCategory.giaDinh => Icons.home_rounded,
        ExpenseCategory.duLich => Icons.flight_rounded,
        ExpenseCategory.thuCung => Icons.pets_rounded,
      };

  /// Each category's own true color for the Add Transaction picker
  /// (selected border + icon tint). Distinct from [ChartCategoryGroupUi],
  /// which buckets yTe/duLich/thuCung under the shared "Khác" pie slice —
  /// the picker still shows their real, unique hues per design handoff.
  Color get ownColor => switch (this) {
        ExpenseCategory.anUong => const Color(0xFF4F46E5),
        ExpenseCategory.shopping => const Color(0xFFF59E0B),
        ExpenseCategory.diLai => const Color(0xFF22C55E),
        ExpenseCategory.giaiTri => const Color(0xFFF43F5E),
        ExpenseCategory.yTe => const Color(0xFF0EA5E9),
        ExpenseCategory.giaDinh => const Color(0xFF8B5CF6),
        ExpenseCategory.duLich => const Color(0xFF14B8A6),
        ExpenseCategory.thuCung => const Color(0xFFEAB308),
      };
}
