import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/viewmodel/recurring_transaction_list_cubit.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/viewmodel/recurring_transaction_list_state.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/widgets/recurring_transaction_row.dart';

/// Screen 10b — reached from Profile → "Giao dịch định kỳ". No FAB; the add
/// action lives in the header's trailing "+" icon (full-screen push form,
/// same convention as Budget/Add Budget).
class RecurringTransactionListPage extends StatefulWidget {
  const RecurringTransactionListPage({super.key});

  @override
  State<RecurringTransactionListPage> createState() =>
      _RecurringTransactionListPageState();
}

class _RecurringTransactionListPageState
    extends State<RecurringTransactionListPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecurringTransactionListCubit>().load();
  }

  Future<void> _openForm(BuildContext context,
      [RecurringTransaction? existing]) async {
    await context.push('/recurring-transactions/form', extra: existing);
    if (context.mounted) context.read<RecurringTransactionListCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
                  child: RefreshIndicator(
                    onRefresh: () =>
                        context.read<RecurringTransactionListCubit>().load(),
                    child: BlocBuilder<RecurringTransactionListCubit,
                        RecurringTransactionListState>(
                      builder: (context, state) {
                        return switch (state) {
                          RecurringTransactionListLoading() => ListView(
                              padding: EdgeInsets.zero,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: AppSpacing.xxl2),
                                  child: AppLoadingIndicator(),
                                ),
                              ],
                            ),
                          RecurringTransactionListError(:final message) =>
                            ListView(
                              padding: EdgeInsets.zero,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                AppErrorView(
                                  message: message,
                                  onRetry: () => context
                                      .read<RecurringTransactionListCubit>()
                                      .load(),
                                ),
                              ],
                            ),
                          RecurringTransactionListLoaded(:final items) =>
                            ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.screenHorizontal,
                                vertical: AppSpacing.mdLg,
                              ),
                              children: [
                                Text(
                                  context
                                      .l10n.recurringTransactionListDescription,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      color: colors.textSecondary),
                                ),
                                const SizedBox(height: AppSpacing.mdLg),
                                if (items.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: AppSpacing.xxl2),
                                    child: AppEmptyView(
                                      icon: Icons.event_repeat_rounded,
                                      message: context.l10n
                                          .recurringTransactionEmptyMessage,
                                    ),
                                  )
                                else
                                  for (final item in items) ...[
                                    RecurringTransactionRow(
                                      recurring: item,
                                      onTap: () => _openForm(context, item),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                  ],
                              ],
                            ),
                        };
                      },
                    ),
                  ),
                ),
              ),
              AppHeader(
                title: context.l10n.recurringTransactionListPageTitle,
                titleFontSize: 19,
                onBack: () => Navigator.of(context).pop(),
                trailingIcon: Icons.add_rounded,
                onTrailingPressed: () => _openForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
