import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/components/empty/app_empty_view.dart';
import '../../../../shared/components/error/app_error_view.dart';
import '../../../../shared/components/loading/app_loading_indicator.dart';
import '../viewmodel/budget_cubit.dart';
import '../viewmodel/budget_state.dart';
import '../widgets/budget_item_card.dart';

/// Screen 9 — no back arrow in the design (reached via Dashboard's budget
/// row or Profile menu; the platform back gesture/button returns).
class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ngân sách', style: textTheme.titleLarge),
                  Icon(Icons.add_circle_rounded, size: 22, color: colors.primary),
                ],
              ),
              Expanded(
                child: BlocBuilder<BudgetCubit, BudgetState>(
                  builder: (context, state) {
                    return switch (state) {
                      BudgetLoading() => const AppLoadingIndicator(),
                      BudgetError(:final message) => AppErrorView(
                          message: message,
                          onRetry: () => context.read<BudgetCubit>().load(),
                        ),
                      BudgetLoaded(items: []) => const AppEmptyView(
                          icon: Icons.account_balance_wallet_rounded,
                          message: 'Chưa có ngân sách nào.\nNhấn + để thiết lập ngân sách đầu tiên.',
                        ),
                      BudgetLoaded(:final items, :final totalBudget, :final totalUsedPercent) =>
                        ListView(
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              'Tổng ngân sách: ${CurrencyFormatter.format(totalBudget)} · Đã dùng $totalUsedPercent%',
                              style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.mdLg),
                            for (final item in items) ...[
                              BudgetItemCard(item: item),
                              const SizedBox(height: AppSpacing.smMd),
                            ],
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
