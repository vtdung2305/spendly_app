import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/chart_category_group.dart';

extension ChartCategoryGroupUi on ChartCategoryGroup {
  Color get color => switch (this) {
        ChartCategoryGroup.anUong => AppCategoryColors.anUong,
        ChartCategoryGroup.shopping => AppCategoryColors.shopping,
        ChartCategoryGroup.diLai => AppCategoryColors.diLai,
        ChartCategoryGroup.giaiTri => AppCategoryColors.giaiTri,
        ChartCategoryGroup.giaDinh => AppCategoryColors.giaDinh,
        ChartCategoryGroup.khac => AppCategoryColors.khac,
      };
}
