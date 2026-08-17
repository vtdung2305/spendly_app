import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/shared/components/list/swipe_to_delete.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/presentation/widgets/transaction_row.dart';
import 'package:spendly_app/features/transaction_history/presentation/viewmodel/history_cubit.dart';
import 'package:spendly_app/features/transaction_history/presentation/viewmodel/history_filter.dart';
import 'package:spendly_app/features/transaction_history/presentation/viewmodel/history_state.dart';
import 'package:spendly_app/features/transaction_history/presentation/widgets/filter_chip_panel.dart';
import 'package:spendly_app/features/transaction_history/presentation/widgets/history_search_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _searchController = TextEditingController();
  bool _filterOpen = false;
  String _searchQuery = '';
  HistoryFilter _filter = HistoryFilter.empty;

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() => context
      .read<HistoryCubit>()
      .load(searchQuery: _searchQuery, filter: _filter);

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _filter = HistoryFilter.empty;
      _searchController.clear();
    });
    _reload();
  }

  Future<void> _editTransaction(
      BuildContext context, Transaction transaction) async {
    await context.push('/add-transaction', extra: transaction);
    if (context.mounted) _reload();
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
    final headerHeight = MediaQuery.paddingOf(context).top + 76;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                top: headerHeight,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.mdLg),
                        HistorySearchBar(
                          controller: _searchController,
                          onChanged: (query) {
                            _searchQuery = query;
                            _reload();
                          },
                          filterOpen: _filterOpen,
                          onToggleFilter: () =>
                              setState(() => _filterOpen = !_filterOpen),
                        ),
                        if (_filterOpen) ...[
                          const SizedBox(height: AppSpacing.sm),
                          FilterChipPanel(
                            filter: _filter,
                            hasActiveFilters:
                                _filter.isActive || _searchQuery.isNotEmpty,
                            onDateFromChanged: (date) {
                              setState(
                                  () => _filter = _filter.copyWith(
                                      dateFrom: date, clearDateFrom: date == null));
                              _reload();
                            },
                            onDateToChanged: (date) {
                              setState(() => _filter = _filter.copyWith(
                                  dateTo: date, clearDateTo: date == null));
                              _reload();
                            },
                            onQuickFilterChanged: (quickFilter) {
                              setState(() =>
                                  _filter = _filter.copyWith(quickFilter: quickFilter));
                              _reload();
                            },
                            onClearFilters: _clearFilters,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.mdLg),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _reload,
                            child: BlocBuilder<HistoryCubit, HistoryState>(
                              builder: (context, state) {
                                return switch (state) {
                                  HistoryLoading() => ListView(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: AppSpacing.xxl2),
                                          child: AppLoadingIndicator(),
                                        ),
                                      ],
                                    ),
                                  HistoryError(:final message) => ListView(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        AppErrorView(
                                          message: message,
                                          onRetry: _reload,
                                        ),
                                      ],
                                    ),
                                  HistoryLoaded(
                                    transactions: [],
                                    :final searchQuery,
                                    :final filter,
                                  )
                                      when searchQuery.isNotEmpty ||
                                          filter.isActive =>
                                    LayoutBuilder(
                                      builder: (context, constraints) =>
                                          ListView(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          SizedBox(
                                            height: constraints.maxHeight,
                                            child: AppEmptyView(
                                              icon: Icons.search_off_rounded,
                                              message: context
                                                  .l10n.historyNoResultsMessage,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  HistoryLoaded(transactions: []) =>
                                    LayoutBuilder(
                                      builder: (context, constraints) =>
                                          ListView(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          SizedBox(
                                            height: constraints.maxHeight,
                                            child: AppEmptyView(
                                              icon: Icons.receipt_long_rounded,
                                              message: context
                                                  .l10n.historyEmptyMessage,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  HistoryLoaded(:final transactions) =>
                                    ListView(
                                      padding: EdgeInsets.zero,
                                      children: [
                                        for (final t in transactions) ...[
                                          SwipeToDelete(
                                            itemKey: ValueKey(t.id),
                                            confirmTitle: context.l10n
                                                .transactionDeleteConfirmTitle,
                                            confirmDescription: context.l10n
                                                .feedbackKitConfirmDialogDesc,
                                            onTap: () =>
                                                _editTransaction(context, t),
                                            onDelete: () => _deleteTransaction(
                                                context, t.id),
                                            child:
                                                TransactionRow(transaction: t),
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
              ),
              AppHeader(
                title: context.l10n.historyTitle,
                titleFontSize: 19,
                onBack: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        floatingActionButton: AppFab(
          onPressed: () async {
            await context.push('/add-transaction');
            if (context.mounted) _reload();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
