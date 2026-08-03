import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_confirm_dialog.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/shared/components/toggles/app_toggle_switch.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/amount_input.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/category_picker_grid.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/transaction_type_segmented_control.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/viewmodel/recurring_transaction_form_cubit.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/viewmodel/recurring_transaction_form_state.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

/// Screen 10c — full-screen push for both Add and Edit (Edit adds a Delete
/// button at the bottom), per design handoff.
class RecurringTransactionFormPage extends StatefulWidget {
  const RecurringTransactionFormPage({super.key});

  @override
  State<RecurringTransactionFormPage> createState() =>
      _RecurringTransactionFormPageState();
}

class _RecurringTransactionFormPageState
    extends State<RecurringTransactionFormPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecurringTransactionFormCubit>().loadCategories();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.delete_rounded,
      title: context.l10n.recurringTransactionDeleteConfirmTitle,
      description: context.l10n.recurringTransactionDeleteConfirmDesc,
      cancelLabel: context.l10n.commonCancel,
      confirmLabel: context.l10n.commonDelete,
    );
    if (confirmed && context.mounted) {
      context.read<RecurringTransactionFormCubit>().delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final headerHeight = MediaQuery.paddingOf(context).top + 76;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MultiBlocListener(
        listeners: [
          BlocListener<RecurringTransactionFormCubit,
              RecurringTransactionFormState>(
            listenWhen: (previous, current) =>
                !previous.saved && current.saved,
            listener: (context, state) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                  context, context.l10n.recurringTransactionSavedSnackbar);
            },
          ),
          BlocListener<RecurringTransactionFormCubit,
              RecurringTransactionFormState>(
            listenWhen: (previous, current) =>
                !previous.deleted && current.deleted,
            listener: (context, state) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                  context, context.l10n.recurringTransactionDeletedSnackbar);
            },
          ),
          BlocListener<RecurringTransactionFormCubit,
              RecurringTransactionFormState>(
            listenWhen: (previous, current) =>
                current.errorMessage != null &&
                current.errorMessage != previous.errorMessage,
            listener: (context, state) =>
                AppSnackbar.showError(context, state.errorMessage!),
          ),
        ],
        child: Scaffold(
          backgroundColor: colors.background,
          body: BlocBuilder<RecurringTransactionFormCubit,
              RecurringTransactionFormState>(
            builder: (context, state) {
              final cubit = context.read<RecurringTransactionFormCubit>();
              final categories = state.type == TransactionType.expense
                  ? state.expenseCategories
                  : state.incomeCategories;

              return SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                      top: headerHeight,
                      child: SafeArea(
                        top: false,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal,
                            vertical: AppSpacing.mdLg,
                          ),
                          children: [
                            TransactionTypeSegmentedControl(
                              selected: state.type,
                              onChanged: cubit.selectType,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _FieldLabel(
                                context.l10n.recurringTransactionFormLabelField),
                            const SizedBox(height: AppSpacing.xs),
                            _LabelField(
                              initialValue: state.label,
                              hintText: context
                                  .l10n.recurringTransactionFormLabelHint,
                              onChanged: cubit.setLabel,
                            ),
                            const SizedBox(height: AppSpacing.mdLg),
                            _FieldLabel(context
                                .l10n.recurringTransactionFormCategoryLabel),
                            const SizedBox(height: AppSpacing.xs),
                            CategoryPickerGrid(
                              categories: categories,
                              selected: state.category,
                              onSelected: cubit.selectCategory,
                              style: state.type == TransactionType.income
                                  ? CategoryPickerStyle.list
                                  : CategoryPickerStyle.grid,
                            ),
                            const SizedBox(height: AppSpacing.mdLg),
                            _FieldLabel(
                                context.l10n.recurringTransactionFormAmountLabel),
                            const SizedBox(height: AppSpacing.xs),
                            AmountInput(
                                initialAmount: state.amount,
                                onChanged: cubit.setAmount),
                            const SizedBox(height: AppSpacing.mdLg),
                            _FieldLabel(
                                context.l10n.recurringTransactionFormDayLabel),
                            const SizedBox(height: AppSpacing.xs),
                            _DayPicker(
                              selectedDay: state.dayOfMonth,
                              onSelected: cubit.selectDay,
                            ),
                            const SizedBox(height: AppSpacing.mdLg),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.mdLg),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.card),
                                border: Border.all(color: colors.border),
                                boxShadow: AppShadow.card,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.l10n
                                              .recurringTransactionFormActiveTitle,
                                          style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          context.l10n
                                              .recurringTransactionFormActiveSubtitle,
                                          style: TextStyle(
                                              fontSize: 11.5,
                                              color: colors.textTertiary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppToggleSwitch(
                                    value: state.isActive,
                                    onTap: cubit.toggleActive,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            AppButton(
                              label: context
                                  .l10n.recurringTransactionFormSaveButton,
                              isLoading: state.isSaving,
                              onPressed: state.isValid ? cubit.save : null,
                            ),
                            if (cubit.isEditing) ...[
                              const SizedBox(height: AppSpacing.sm),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: () => _confirmDelete(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.dangerTint,
                                    foregroundColor: colors.danger,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.lg)),
                                  ),
                                  icon: const Icon(Icons.delete_rounded,
                                      size: 19),
                                  label: Text(
                                    context.l10n
                                        .recurringTransactionFormDeleteButton,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    AppHeader(
                      title: cubit.isEditing
                          ? context.l10n.recurringTransactionFormEditTitle
                          : context.l10n.recurringTransactionFormAddTitle,
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
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: context.colors.textSecondary,
      ),
    );
  }
}

class _LabelField extends StatelessWidget {
  const _LabelField({
    required this.initialValue,
    required this.hintText,
    required this.onChanged,
  });

  final String initialValue;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _DayPicker extends StatelessWidget {
  const _DayPicker({required this.selectedDay, required this.onSelected});

  final int selectedDay;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 28,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final day = index + 1;
          final isSelected = day == selectedDay;
          return InkWell(
            onTap: () => onSelected(day),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                    color: isSelected ? colors.primary : colors.border),
              ),
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : colors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
