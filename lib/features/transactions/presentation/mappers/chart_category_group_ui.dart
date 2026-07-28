import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/features/transactions/domain/entities/chart_category_group.dart';

extension ChartCategoryGroupUi on ChartCategoryGroup {
  String labelText(BuildContext context) => switch (this) {
        ChartCategoryGroup.anUong => context.l10n.categoryFood,
        ChartCategoryGroup.shopping => context.l10n.categoryShopping,
        ChartCategoryGroup.diLai => context.l10n.categoryTransport,
        ChartCategoryGroup.giaiTri => context.l10n.categoryEntertainment,
        ChartCategoryGroup.giaDinh => context.l10n.categoryFamily,
        ChartCategoryGroup.khac => context.l10n.categoryOther,
      };

  Color get color => switch (this) {
        ChartCategoryGroup.anUong => AppCategoryColors.anUong,
        ChartCategoryGroup.shopping => AppCategoryColors.shopping,
        ChartCategoryGroup.diLai => AppCategoryColors.diLai,
        ChartCategoryGroup.giaiTri => AppCategoryColors.giaiTri,
        ChartCategoryGroup.giaDinh => AppCategoryColors.giaDinh,
        ChartCategoryGroup.khac => AppCategoryColors.khac,
      };
}
