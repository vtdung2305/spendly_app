import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty/app_empty_view.dart';
import '../../../../shared/components/error/app_error_view.dart';
import '../../../../shared/components/loading/app_loading_indicator.dart';
import '../../../transactions/presentation/widgets/transaction_row.dart';
import '../viewmodel/history_cubit.dart';
import '../viewmodel/history_state.dart';
import '../widgets/filter_chip_panel.dart';
import '../widgets/history_search_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _filterOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Text('Lịch sử giao dịch', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              HistorySearchBar(
                onChanged: (query) => context.read<HistoryCubit>().load(searchQuery: query),
                filterOpen: _filterOpen,
                onToggleFilter: () => setState(() => _filterOpen = !_filterOpen),
              ),
              if (_filterOpen) ...[
                const SizedBox(height: AppSpacing.sm),
                const FilterChipPanel(),
              ],
              Expanded(
                child: BlocBuilder<HistoryCubit, HistoryState>(
                  builder: (context, state) {
                    return switch (state) {
                      HistoryLoading() => const AppLoadingIndicator(),
                      HistoryError(:final message) => AppErrorView(
                          message: message,
                          onRetry: () => context.read<HistoryCubit>().load(),
                        ),
                      HistoryLoaded(transactions: [], :final searchQuery) when searchQuery.isNotEmpty =>
                        const AppEmptyView(
                          icon: Icons.search_off_rounded,
                          message: 'Không tìm thấy giao dịch',
                        ),
                      HistoryLoaded(transactions: []) => const AppEmptyView(
                          icon: Icons.receipt_long_rounded,
                          message: 'Chưa có giao dịch nào',
                        ),
                      HistoryLoaded(:final transactions) => ListView(
                          padding: const EdgeInsets.only(top: AppSpacing.mdLg),
                          children: [
                            for (final t in transactions) TransactionRow(transaction: t),
                          ],
                        ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
