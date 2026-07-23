import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty/app_empty_view.dart';
import '../../../../shared/components/error/app_error_view.dart';
import '../../../../shared/components/loading/app_loading_indicator.dart';
import '../viewmodel/income_cubit.dart';
import '../viewmodel/income_state.dart';
import '../widgets/income_row.dart';
import '../widgets/month_chips_row.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  int _selectedMonthChip = 0;

  @override
  void initState() {
    super.initState();
    context.read<IncomeCubit>().load();
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
                  Text('Thu nhập', style: textTheme.titleLarge),
                  Icon(Icons.add_circle_rounded, size: 22, color: colors.primary),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              MonthChipsRow(
                selectedIndex: _selectedMonthChip,
                onSelected: (i) => setState(() => _selectedMonthChip = i),
              ),
              Expanded(
                child: BlocBuilder<IncomeCubit, IncomeState>(
                  builder: (context, state) {
                    return switch (state) {
                      IncomeLoading() => const AppLoadingIndicator(),
                      IncomeError(:final message) => AppErrorView(
                          message: message,
                          onRetry: () => context.read<IncomeCubit>().load(),
                        ),
                      IncomeLoaded(transactions: []) => const AppEmptyView(
                          icon: Icons.savings_rounded,
                          message: 'Chưa có khoản thu nào trong tháng này.',
                        ),
                      IncomeLoaded(:final transactions) => ListView(
                          padding: const EdgeInsets.only(top: AppSpacing.mdLg),
                          children: [
                            for (final t in transactions) IncomeRow(transaction: t),
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
