import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/localization/weekday_labels.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// A run of transactions sharing the same calendar day, in the order they
/// appear in the (already date-descending) source list.
class HistoryDateGroup {
  const HistoryDateGroup({required this.date, required this.transactions});
  final DateTime date;
  final List<Transaction> transactions;
}

/// Groups an already date-descending transaction list into consecutive
/// same-day runs — one [HistoryDateGroup] per calendar day, per History's
/// grouped-list layout.
List<HistoryDateGroup> groupTransactionsByDate(List<Transaction> transactions) {
  final groups = <HistoryDateGroup>[];
  for (final t in transactions) {
    final day = DateTime(t.date.year, t.date.month, t.date.day);
    if (groups.isNotEmpty && groups.last.date == day) {
      groups.last.transactions.add(t);
    } else {
      groups.add(HistoryDateGroup(date: day, transactions: [t]));
    }
  }
  return groups;
}

/// "Thứ 2, 17/08" section header for a [HistoryDateGroup] — passed as
/// [SliverStickyHeader.header] so the package sticks it to the top of the
/// list while its group scrolls past, then swaps it for the next group's
/// header (rather than stacking, which plain `SliverPersistentHeader`s do).
class HistoryDateGroupHeader extends StatelessWidget {
  const HistoryDateGroupHeader({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label =
        '${fullWeekdayLabel(context, date.weekday)}, ${DateFormat('dd/MM').format(date)}';
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      color: colors.background,
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(fontSize: 12, color: colors.textSecondary),
      ),
    );
  }
}
