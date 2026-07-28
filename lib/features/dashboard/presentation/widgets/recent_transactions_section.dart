import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/presentation/widgets/transaction_row.dart';

/// "Giao dịch gần đây" header + "Xem tất cả" link + up-to-10 [TransactionRow]s,
/// per Dashboard layout row 6.
class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({
    required this.transactions,
    required this.onSeeAll,
    super.key,
  });

  final List<Transaction> transactions;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.dashboardRecentTransactionsTitle,
                style: textTheme.titleSmall),
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                context.l10n.dashboardSeeAllButton,
                style: TextStyle(color: colors.primary, fontSize: 13),
              ),
            ),
          ],
        ),
        for (final transaction in transactions) ...[
          TransactionRow(transaction: transaction),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
