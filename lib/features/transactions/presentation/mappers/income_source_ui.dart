import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/features/transactions/domain/entities/income_source.dart';

extension IncomeSourceUi on IncomeSource {
  IconData get icon => switch (this) {
        IncomeSource.luong => Icons.payments_rounded,
        IncomeSource.freelance => Icons.laptop_mac_rounded,
        IncomeSource.bonus => Icons.redeem_rounded,
        IncomeSource.khac => Icons.more_horiz_rounded,
      };

  String labelText(BuildContext context) => switch (this) {
        IncomeSource.luong => context.l10n.incomeSourceSalary,
        IncomeSource.freelance => context.l10n.incomeSourceFreelance,
        IncomeSource.bonus => context.l10n.incomeSourceBonus,
        IncomeSource.khac => context.l10n.categoryOther,
      };
}
