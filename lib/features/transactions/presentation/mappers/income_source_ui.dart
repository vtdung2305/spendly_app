import 'package:flutter/material.dart';

import '../../domain/entities/income_source.dart';

extension IncomeSourceUi on IncomeSource {
  IconData get icon => switch (this) {
        IncomeSource.luong => Icons.payments_rounded,
        IncomeSource.freelance => Icons.laptop_mac_rounded,
        IncomeSource.bonus => Icons.redeem_rounded,
        IncomeSource.khac => Icons.more_horiz_rounded,
      };
}
