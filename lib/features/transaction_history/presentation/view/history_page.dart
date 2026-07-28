import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/list/swipe_to_delete.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/presentation/widgets/transaction_row.dart';
import 'package:spendly_app/features/transaction_history/presentation/viewmodel/history_cubit.dart';
import 'package:spendly_app/features/transaction_history/presentation/viewmodel/history_state.dart';
import 'package:spendly_app/features/transaction_history/presentation/widgets/filter_chip_panel.dart';
import 'package:spendly_app/features/transaction_history/presentation/widgets/history_search_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _filterOpen = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().load();
  }

  Future<void> _editTransaction(
      BuildContext context, Transaction transaction) async {
    await context.push('/add-transaction', extra: transaction);
    if (context.mounted) {
      context.read<HistoryCubit>().load(searchQuery: _searchQuery);
    }
  }

  Future<void> _deleteTransaction(BuildContext context, String id) async {
    final error = await context.read<HistoryCubit>().delete(id);
    if (!context.mounted) return;
    if (error != null) {
      AppSnackbar.showError(context, error);
    } else {
      AppSnackbar.showSuccess(context, context.l10n.transactionDeletedSnackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Text(context.l10n.historyTitle, style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              HistorySearchBar(
                onChanged: (query) {
                  _searchQuery = query;
                  context.read<HistoryCubit>().load(searchQuery: query);
                },
                filterOpen: _filterOpen,
                onToggleFilter: () =>
                    setState(() => _filterOpen = !_filterOpen),
              ),
              if (_filterOpen) ...[
                const SizedBox(height: AppSpacing.sm),
                const FilterChipPanel(),
              ],
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context
                      .read<HistoryCubit>()
                      .load(searchQuery: _searchQuery),
                  child: BlocBuilder<HistoryCubit, HistoryState>(
                    builder: (context, state) {
                      return switch (state) {
                        HistoryLoading() => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: AppSpacing.xxl2),
                                child: AppLoadingIndicator(),
                              ),
                            ],
                          ),
                        HistoryError(:final message) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              AppErrorView(
                                message: message,
                                onRetry: () => context
                                    .read<HistoryCubit>()
                                    .load(searchQuery: _searchQuery),
                              ),
                            ],
                          ),
                        HistoryLoaded(transactions: [], :final searchQuery)
                            when searchQuery.isNotEmpty =>
                          LayoutBuilder(
                            builder: (context, constraints) => ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight,
                                  child: AppEmptyView(
                                    icon: Icons.search_off_rounded,
                                    message:
                                        context.l10n.historyNoResultsMessage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        HistoryLoaded(transactions: []) => LayoutBuilder(
                            builder: (context, constraints) => ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight,
                                  child: AppEmptyView(
                                    icon: Icons.receipt_long_rounded,
                                    message: context.l10n.historyEmptyMessage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        HistoryLoaded(:final transactions) => ListView(
                            padding:
                                const EdgeInsets.only(top: AppSpacing.mdLg),
                            children: [
                              for (final t in transactions) ...[
                                SwipeToDelete(
                                  itemKey: ValueKey(t.id),
                                  confirmTitle: context
                                      .l10n.transactionDeleteConfirmTitle,
                                  confirmDescription:
                                      context.l10n.feedbackKitConfirmDialogDesc,
                                  onTap: () => _editTransaction(context, t),
                                  onDelete: () =>
                                      _deleteTransaction(context, t.id),
                                  child: TransactionRow(transaction: t),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ],
                          ),
                      };
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () async {
          await context.push('/add-transaction');
          if (context.mounted) {
            context.read<HistoryCubit>().load(searchQuery: _searchQuery);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
