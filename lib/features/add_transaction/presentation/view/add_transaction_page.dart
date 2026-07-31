import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/dialogs/center_dialog.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_edit_args.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/add_transaction/presentation/viewmodel/add_transaction_cubit.dart';
import 'package:spendly_app/features/add_transaction/presentation/viewmodel/add_transaction_state.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/category_picker_grid.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/date_note_card.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/date_picker_dialog_content.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/transaction_amount_card.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/transaction_type_segmented_control.dart';

/// Unified Add Expense/Income screen (screens 5 & 6 in the design handoff) —
/// entry point sets the default tab via [AddTransactionCubit]'s initialTab.
/// Presented as a bottom-sheet-style push (slide-up) per design.
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddTransactionCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Header has a leading back button (44px row), taller than a
    // title-only header.
    final headerHeight = MediaQuery.paddingOf(context).top + 76;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddTransactionCubit, AddTransactionState>(
            listenWhen: (previous, current) => !previous.saved && current.saved,
            listener: (context, state) {
              final cubit = context.read<AddTransactionCubit>();
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                context,
                cubit.isEditing
                    ? context.l10n.transactionUpdatedSnackbar
                    : state.type == TransactionType.expense
                        ? context.l10n.addTransactionSavedExpenseSnackbar
                        : context.l10n.addTransactionSavedIncomeSnackbar,
              );
            },
          ),
          BlocListener<AddTransactionCubit, AddTransactionState>(
            listenWhen: (previous, current) =>
                current.errorMessage != null &&
                current.errorMessage != previous.errorMessage,
            listener: (context, state) =>
                AppSnackbar.showError(context, state.errorMessage!),
          ),
        ],
        // A local ScaffoldMessenger keeps this page's snackbars (save/error)
        // scoped to its own Scaffold — without it, Flutter's "shown on all
        // registered root Scaffolds" behavior duplicates the snackbar onto
        // whatever screen is still mounted underneath (e.g. Calendar's day
        // sheet), rendering a second copy behind this page.
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: colors.background,
            body: BlocBuilder<AddTransactionCubit, AddTransactionState>(
              builder: (context, state) {
                final cubit = context.read<AddTransactionCubit>();
                return SizedBox.expand(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: headerHeight,
                        child: SafeArea(
                          top: false,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.screenHorizontal,
                                  ),
                                  children: [
                                    const SizedBox(height: AppSpacing.mdLg),
                                    TransactionTypeSegmentedControl(
                                      selected: state.type,
                                      onChanged: cubit.selectTab,
                                    ),
                                    const SizedBox(height: AppSpacing.lgXl),
                                    TransactionAmountCard(
                                      type: state.type,
                                      initialAmount: cubit.initialAmount,
                                      onChanged: cubit.setAmount,
                                    ),
                                    const SizedBox(height: AppSpacing.lgXl),
                                    _buildCategorySection(
                                        context, state, cubit),
                                    const SizedBox(height: AppSpacing.lgXl),
                                    DateNoteCard(
                                      date: state.date ?? DateTime.now(),
                                      onDateTap: () => _pickDate(context, cubit,
                                          state.date ?? DateTime.now()),
                                      initialNote: cubit.initialNote,
                                      onNoteChanged: cubit.setNote,
                                    ),
                                    const SizedBox(height: AppSpacing.xl),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.screenHorizontal,
                                  0,
                                  AppSpacing.screenHorizontal,
                                  AppSpacing.mdLg,
                                ),
                                child: Column(
                                  children: [
                                    AppButton(
                                      label: cubit.isEditing
                                          ? context
                                              .l10n.editTransactionSaveButton
                                          : context
                                              .l10n.addTransactionSaveButton,
                                      isLoading: state.isSaving,
                                      onPressed:
                                          state.isValid ? cubit.save : null,
                                    ),
                                    if (!state.isValid) ...[
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        _saveHint(context, state),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 11.5,
                                            color: colors.textTertiary),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppHeader(
                        title: cubit.isEditing
                            ? context.l10n.editTransactionPageTitle
                            : context.l10n.addTransactionPageTitle,
                        titleFontSize: 18,
                        onBack: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _saveHint(BuildContext context, AddTransactionState state) {
    if (state.category == null) {
      return state.type == TransactionType.expense
          ? context.l10n.addTransactionHintChooseCategory
          : context.l10n.addTransactionHintChooseSource;
    }
    return context.l10n.addTransactionHintEnterAmount;
  }

  Future<void> _pickDate(
    BuildContext context,
    AddTransactionCubit cubit,
    DateTime currentDate,
  ) async {
    final picked = await CenterDialog.show<DateTime>(
      context,
      title: context.l10n.addTransactionDatePickerTitle,
      builder: (_) => DatePickerDialogContent(initialDate: currentDate),
    );
    if (picked != null) cubit.setDate(picked);
  }

  Future<void> _openCreateCategory(BuildContext context,
      AddTransactionCubit cubit, CategoryType type) async {
    await context.push('/categories/edit',
        extra: CategoryEditArgs(createType: type));
    if (context.mounted) cubit.loadCategories();
  }

  Widget _buildCategorySection(
    BuildContext context,
    AddTransactionState state,
    AddTransactionCubit cubit,
  ) {
    final isExpense = state.type == TransactionType.expense;
    final label = isExpense
        ? context.l10n.addTransactionCategoryLabel
        : context.l10n.addTransactionIncomeSourceLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleSmall),
            if (isExpense)
              Text(
                state.category?.label ??
                    context.l10n.addTransactionCategoryUnselectedLabel,
                style: TextStyle(
                    fontSize: 11.5, color: context.colors.textTertiary),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.smMd),

        // Expense (grid) and Income (list) render structurally different
        // widgets — AnimatedSwitcher cross-fades between them instead of
        // hard-cutting, which smooths the tab-switch flicker. (An
        // AnimatedSize was tried here too, to also smooth the height jump,
        // but it left a large persistent empty gap while categories were
        // still loading — removed rather than chase that further.)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isExpense
              ? CategoryPickerGrid(
                  key: const ValueKey('expense'),
                  categories: state.expenseCategories,
                  selected: state.category,
                  onSelected: cubit.selectCategory,
                  onAddCategory: () =>
                      _openCreateCategory(context, cubit, CategoryType.expense),
                )
              : CategoryPickerGrid(
                  key: const ValueKey('income'),
                  categories: state.incomeCategories,
                  selected: state.category,
                  onSelected: cubit.selectCategory,
                  style: CategoryPickerStyle.list,
                ),
        ),
      ],
    );
  }
}
