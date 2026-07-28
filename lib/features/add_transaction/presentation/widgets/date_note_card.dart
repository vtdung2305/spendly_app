import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';

/// Merged "Ngày" + "Ghi chú" card — one bordered/shadowed card split by a
/// divider, per design handoff Add Expense/Add Income layout (previously
/// two separate, unbordered rows).
class DateNoteCard extends StatelessWidget {
  const DateNoteCard({
    required this.date,
    required this.onDateTap,
    required this.initialNote,
    required this.onNoteChanged,
    super.key,
  });

  final DateTime date;
  final VoidCallback onDateTap;
  final String initialNote;
  final ValueChanged<String> onNoteChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final dateLabel = isToday
        ? context.l10n
            .addTransactionDateTodayLabel(DateFormat('dd/MM').format(date))
        : DateFormat('dd/MM/yyyy').format(date);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onDateTap,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.card)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.event_rounded, size: 20, color: colors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.addTransactionDateLabel,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    dateLabel,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.expand_more_rounded,
                      size: 18, color: colors.textTertiary),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: colors.border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            child: Row(
              children: [
                Icon(Icons.notes_rounded,
                    size: 20, color: colors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: initialNote,
                    onChanged: onNoteChanged,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: context.l10n.addTransactionNoteHint,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
