import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_confirm_dialog.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/edit_budget_cubit.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/edit_budget_state.dart';

const _kBudgetPresets = [2000000.0, 3000000.0, 5000000.0, 8000000.0];

/// Screen 9c — adjust or delete an existing category's monthly limit.
/// Category/used-amount are read-only here (delete + recreate to change
/// category), per design handoff.
class EditBudgetPage extends StatelessWidget {
  const EditBudgetPage({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.delete_rounded,
      title: context.l10n.editBudgetDeleteConfirmTitle,
      description: context.l10n.editBudgetDeleteConfirmDesc,
      cancelLabel: context.l10n.commonCancel,
      confirmLabel: context.l10n.commonDelete,
    );
    if (confirmed && context.mounted) {
      context.read<EditBudgetCubit>().delete();
    }
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
          BlocListener<EditBudgetCubit, EditBudgetState>(
            listenWhen: (previous, current) => !previous.saved && current.saved,
            listener: (context, state) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                  context, context.l10n.editBudgetUpdatedSnackbar);
            },
          ),
          BlocListener<EditBudgetCubit, EditBudgetState>(
            listenWhen: (previous, current) =>
                !previous.deleted && current.deleted,
            listener: (context, state) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                  context, context.l10n.editBudgetDeletedSnackbar);
            },
          ),
          BlocListener<EditBudgetCubit, EditBudgetState>(
            listenWhen: (previous, current) =>
                current.errorMessage != null &&
                current.errorMessage != previous.errorMessage,
            listener: (context, state) =>
                AppSnackbar.showError(context, state.errorMessage!),
          ),
        ],
        child: Scaffold(
          backgroundColor: colors.background,
          body: BlocBuilder<EditBudgetCubit, EditBudgetState>(
            builder: (context, state) {
              final cubit = context.read<EditBudgetCubit>();
              final item = cubit.item;
              final tooLow = state.amount > 0 && state.amount < item.usedAmount;

              return SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                      top: headerHeight,
                      child: SafeArea(
                        top: false,
                        child: ListView(
                          padding: const EdgeInsets.all(AppSpacing.mdLg),
                          children: [
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
                                  Container(
                                    height: 44,
                                    width: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: colors.surfaceAlt,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Icon(
                                        categoryIconFor(item.category.iconName),
                                        size: 21,
                                        color: categoryColorFromHex(
                                            item.category.colorHex)),
                                  ),
                                  const SizedBox(width: AppSpacing.smMd),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.category.label,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          context.l10n.editBudgetUsedLabel(
                                            CurrencyFormatter.format(
                                                item.usedAmount),
                                          ),
                                          style: AppTypography.mono(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w400,
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              context.l10n.budgetAddMonthlyLimitLabel,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            _AmountField(
                              amount: state.amount,
                              onChanged: cubit.setAmount,
                            ),
                            if (tooLow) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Row(
                                children: [
                                  Icon(Icons.error_rounded,
                                      size: 14, color: colors.danger),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      context.l10n.editBudgetTooLowWarning,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                              color: colors.danger,
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                for (final preset in _kBudgetPresets) ...[
                                  Expanded(
                                    child: _PresetChip(
                                      amount: preset,
                                      selected: state.amount == preset,
                                      onTap: () => cubit.setAmount(preset),
                                    ),
                                  ),
                                  if (preset != _kBudgetPresets.last)
                                    const SizedBox(width: AppSpacing.xs),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            AppButton(
                              label: context.l10n.editBudgetSaveButton,
                              isLoading: state.isSaving,
                              onPressed: state.isValid ? cubit.save : null,
                            ),
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
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.lg)),
                                ),
                                icon:
                                    const Icon(Icons.delete_rounded, size: 19),
                                label: Text(
                                  context.l10n.editBudgetDeleteButton,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppHeader(
                      title: context.l10n.editBudgetPageTitle,
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

class _AmountField extends StatefulWidget {
  const _AmountField({required this.amount, required this.onChanged});

  /// Current amount from the cubit — may change externally (preset chip
  /// tapped), not just from typing in this field.
  final double amount;
  final ValueChanged<double> onChanged;

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField> {
  late final _controller = TextEditingController(
    text: widget.amount > 0 ? CurrencyFormatter.formatPlain(widget.amount) : '',
  );

  @override
  void didUpdateWidget(covariant _AmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the field in sync when the amount changes from outside this
    // field (e.g. a preset chip) — but not while the user is actively
    // typing, since that already updates the controller directly below.
    if (widget.amount != _parseAmount(_controller.text)) {
      final formatted =
          widget.amount > 0 ? CurrencyFormatter.formatPlain(widget.amount) : '';
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _parseAmount(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly.isEmpty ? 0.0 : double.parse(digitsOnly);
  }

  void _handleChanged(String raw) {
    final amount = _parseAmount(raw);
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _handleChanged,
              style: AppTypography.mono(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: AppTypography.mono(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: colors.textTertiary),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isCollapsed: true,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '₫',
            style: AppTypography.mono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip(
      {required this.amount, required this.selected, required this.onTap});

  final double amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.primaryTint : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: selected ? colors.primary : colors.border),
        ),
        child: Text(
          CurrencyFormatter.formatCompact(amount),
          style: AppTypography.mono(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
