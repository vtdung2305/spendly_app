import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/dialogs/app_confirm_dialog.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/calendar/presentation/viewmodel/calendar_cubit.dart';
import 'package:spendly_app/features/calendar/presentation/viewmodel/calendar_state.dart';

/// Bottom sheet listing a tapped day's transactions. Tap a row to open it
/// full-screen in Add Transaction for editing; a dedicated delete button
/// per row opens a confirm dialog first — per design handoff.
class DayTransactionsSheet extends StatefulWidget {
  const DayTransactionsSheet({
    required this.day,
    required this.month,
    required this.year,
    super.key,
  });

  final int day;
  final int month;
  final int year;

  @override
  State<DayTransactionsSheet> createState() => _DayTransactionsSheetState();
}

class _DayTransactionsSheetState extends State<DayTransactionsSheet> {
  Future<void> _editTransaction(Transaction transaction) async {
    await context.push('/add-transaction', extra: transaction);
    if (!mounted) return;
    final cubit = context.read<CalendarCubit>();
    final state = cubit.state;
    if (state is CalendarLoaded) {
      await cubit.load(state.month);
      await cubit.selectDay(widget.day);
    }
  }

  Future<void> _confirmDelete(Transaction transaction) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.delete_rounded,
      title: context.l10n.calendarDeleteConfirmTitle,
      description: context.l10n.feedbackKitConfirmDialogDesc,
      cancelLabel: context.l10n.commonCancel,
      confirmLabel: context.l10n.commonDelete,
    );
    if (!confirmed || !mounted) return;
    final error =
        await context.read<CalendarCubit>().deleteTransaction(transaction.id);
    if (!mounted) return;
    if (error != null) {
      AppSnackbar.showError(context, error);
    } else {
      AppSnackbar.showSuccess(
          context, context.l10n.calendarDeletedTransactionSnackbar);
    }
  }

  Future<void> _addTransaction() async {
    await context.push('/add-transaction');
    if (!mounted) return;
    final cubit = context.read<CalendarCubit>();
    final state = cubit.state;
    if (state is CalendarLoaded) {
      await cubit.load(state.month);
      await cubit.selectDay(widget.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final transactions =
            state is CalendarLoaded && state.selectedDay == widget.day
                ? state.dayTransactions
                : null;
        final dayTotal =
            transactions?.fold<double>(0, (sum, t) => sum + t.amount) ?? 0;

        // A transparent Scaffold gives this sheet its own ScaffoldMessenger
        // host — without it, AppSnackbar's ScaffoldMessenger.of(context)
        // resolves to CalendarPage's Scaffold underneath, and the SnackBar
        // renders behind this modal route instead of above it. The
        // ScaffoldMessenger this Scaffold registers with is provided by the
        // caller (see CalendarPage._openDay) wrapping this whole widget —
        // it must be an ancestor of `this.context` (used by
        // _confirmDelete/_editTransaction/_addTransaction below) for their
        // AppSnackbar calls to resolve to it instead of the app-wide one.
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.mdLg,
                  AppSpacing.smMd,
                  AppSpacing.mdLg,
                  AppSpacing.xl2,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.sheet)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 40,
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        decoration: BoxDecoration(
                            color: colors.border,
                            borderRadius:
                                BorderRadius.circular(AppRadius.full)),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.calendarDaySheetTitle(
                                  widget.day.toString(),
                                  widget.month.toString().padLeft(2, '0'),
                                  widget.year.toString(),
                                ),
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 3),
                              if (transactions != null)
                                Row(
                                  children: [
                                    Text(
                                      context.l10n.calendarDaySheetSummary(
                                          transactions.length.toString()),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colors.textSecondary),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      CurrencyFormatter.format(dayTotal),
                                      style: AppTypography.mono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: colors.danger,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Material(
                          color: colors.surfaceAlt,
                          borderRadius: BorderRadius.circular(11),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(11),
                            child: SizedBox(
                              height: 36,
                              width: 36,
                              child: Icon(Icons.close_rounded,
                                  size: 19, color: colors.textPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (transactions != null && transactions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        child: Text(
                          context.l10n
                              .calendarDaySheetEditHint(
                                  transactions.length.toString())
                              .toUpperCase(),
                          style: AppTypography.mono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: colors.textTertiary,
                            letterSpacing: 0.06 * 10.5,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xs),
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colors.surfaceAlt,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: transactions == null
                            ? const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.mdLg),
                                child: Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2)),
                              )
                            : transactions.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppSpacing.xxl,
                                        horizontal: AppSpacing.lgXl),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.receipt_long_rounded,
                                            size: 34,
                                            color: colors.textTertiary),
                                        const SizedBox(height: 10),
                                        Text(
                                          context.l10n.calendarDayEmptyMessage,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600,
                                              color: colors.textPrimary),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          context.l10n.calendarDayEmptySubtitle,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 11.5,
                                              color: colors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: transactions.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                            height: 1, color: colors.border),
                                    itemBuilder: (context, index) => _DayTxRow(
                                      transaction: transactions[index],
                                      onEdit: () =>
                                          _editTransaction(transactions[index]),
                                      onDelete: () =>
                                          _confirmDelete(transactions[index]),
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.smMd),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: _addTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md)),
                        ),
                        icon: const Icon(Icons.add_rounded,
                            size: 19, color: Colors.white),
                        label: Text(
                          context.l10n.addTransactionPageTitle,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DayTxRow extends StatelessWidget {
  const _DayTxRow(
      {required this.transaction,
      required this.onEdit,
      required this.onDelete});

  final Transaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isIncome = transaction.type == TransactionType.income;
    // Per design: the amount text uses success/danger, but the row's icon
    // tile uses success/primary — expense rows are NOT red here.
    final amountColor = isIncome ? colors.success : colors.danger;
    final iconColor = isIncome ? colors.success : colors.primary;
    final icon = transaction.category == null
        ? Icons.category_rounded
        : categoryIconFor(transaction.category!.iconName);
    final label = transaction.note?.isNotEmpty == true
        ? transaction.note!
        : transaction.displayLabel;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onEdit,
              child: Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 17, color: iconColor),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          transaction.displayLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10.5, color: colors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
                    style: AppTypography.mono(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: amountColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 44,
              width: 44,
              child: Icon(Icons.delete_rounded, size: 17, color: colors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
