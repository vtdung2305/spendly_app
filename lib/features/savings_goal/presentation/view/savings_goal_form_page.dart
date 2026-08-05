import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/date_picker_dialog_content.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_confirm_dialog.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/dialogs/center_dialog.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/features/savings_goal/presentation/viewmodel/savings_goal_form_cubit.dart';
import 'package:spendly_app/features/savings_goal/presentation/viewmodel/savings_goal_form_state.dart';

/// Screen 4c — reached from Savings Goal Detail's header "+" (create) or by
/// tapping an existing goal's card (edit). Field container/label/button
/// match the design mock's `inputStyle`/`fieldLabelStyle`/`btnPrimary`.
class SavingsGoalFormPage extends StatelessWidget {
  const SavingsGoalFormPage({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.delete_rounded,
      title: context.l10n.savingsGoalDeleteConfirmTitle,
      description: context.l10n.savingsGoalDeleteConfirmDesc,
      cancelLabel: context.l10n.commonCancel,
      confirmLabel: context.l10n.commonDelete,
    );
    if (confirmed && context.mounted) {
      context.read<SavingsGoalFormCubit>().delete();
    }
  }

  Future<void> _pickDeadline(
      BuildContext context, DateTime currentDeadline) async {
    final picked = await CenterDialog.show<DateTime>(
      context,
      title: context.l10n.savingsGoalFormDeadlineLabel,
      builder: (_) => DatePickerDialogContent(initialDate: currentDeadline),
    );
    if (picked != null && context.mounted) {
      context.read<SavingsGoalFormCubit>().setDeadline(picked);
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
          BlocListener<SavingsGoalFormCubit, SavingsGoalFormState>(
            listenWhen: (previous, current) =>
                !previous.saved && current.saved,
            listener: (context, state) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                  context, context.l10n.savingsGoalFormSavedSnackbar);
            },
          ),
          BlocListener<SavingsGoalFormCubit, SavingsGoalFormState>(
            listenWhen: (previous, current) =>
                !previous.deleted && current.deleted,
            listener: (context, state) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                  context, context.l10n.savingsGoalFormDeletedSnackbar);
            },
          ),
          BlocListener<SavingsGoalFormCubit, SavingsGoalFormState>(
            listenWhen: (previous, current) =>
                current.errorMessage != null &&
                current.errorMessage != previous.errorMessage,
            listener: (context, state) =>
                AppSnackbar.showError(context, state.errorMessage!),
          ),
        ],
        child: Scaffold(
          backgroundColor: colors.background,
          body: BlocBuilder<SavingsGoalFormCubit, SavingsGoalFormState>(
            builder: (context, state) {
              final cubit = context.read<SavingsGoalFormCubit>();
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
                            _FieldLabel(context.l10n.savingsGoalFormNameLabel),
                            const SizedBox(height: 6),
                            _BorderedField(
                              child: TextFormField(
                                initialValue: state.name,
                                onChanged: cubit.setName,
                                style: const TextStyle(fontSize: 14.5),
                                decoration: InputDecoration(
                                  hintText:
                                      context.l10n.savingsGoalFormNameHint,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  isCollapsed: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.mdLg),
                            _FieldLabel(
                                context.l10n.savingsGoalFormTargetLabel),
                            const SizedBox(height: 6),
                            _AmountField(
                              initialAmount: state.targetAmount,
                              onChanged: cubit.setTargetAmount,
                            ),
                            const SizedBox(height: AppSpacing.mdLg),
                            _FieldLabel(
                                context.l10n.savingsGoalFormDeadlineLabel),
                            const SizedBox(height: 6),
                            InkWell(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                              onTap: () =>
                                  _pickDeadline(context, state.deadline),
                              child: _BorderedField(
                                child: Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(state.deadline),
                                  style: TextStyle(
                                      fontSize: 14.5,
                                      color: colors.textPrimary),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.mdLg),
                            _FieldLabel(
                                context.l10n.savingsGoalFormInitialLabel),
                            const SizedBox(height: 6),
                            _AmountField(
                              initialAmount: state.initialAmount,
                              onChanged: cubit.setInitialAmount,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            AppButton(
                              label: context.l10n.savingsGoalFormSaveButton,
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
                                    context.l10n.savingsGoalFormDeleteButton,
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
                      title: context.l10n.savingsGoalFormPageTitle,
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
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: context.colors.textSecondary,
      ),
    );
  }
}

/// Matches the design mock's `inputStyle` exactly: 50px height, 1px
/// Border, Surface bg, radius 14, 14px horizontal padding, 10px gap to a
/// trailing widget.
class _BorderedField extends StatelessWidget {
  const _BorderedField({required this.child, this.trailing});

  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _AmountField extends StatefulWidget {
  const _AmountField({required this.initialAmount, required this.onChanged});

  final double initialAmount;
  final ValueChanged<double> onChanged;

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField> {
  late final _controller = TextEditingController(
    text: widget.initialAmount > 0
        ? CurrencyFormatter.formatPlain(widget.initialAmount)
        : '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = digitsOnly.isEmpty ? 0.0 : double.parse(digitsOnly);
    final formatted =
        digitsOnly.isEmpty ? '' : CurrencyFormatter.formatPlain(amount);
    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    widget.onChanged(amount);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _BorderedField(
      trailing: Text(
        '₫',
        style: TextStyle(fontSize: 13, color: colors.textTertiary),
      ),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: _handleChanged,
        style: AppTypography.mono(
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            color: colors.textPrimary),
        decoration: const InputDecoration(
          hintText: '0',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          isCollapsed: true,
        ),
      ),
    );
  }
}
