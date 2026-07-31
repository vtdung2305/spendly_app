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
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_edit_cubit.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_edit_state.dart';

/// Screen 14b — Create/Edit Category, reached from Category Management's
/// "+" / row tap / "Thêm danh mục mới".
class CategoryEditPage extends StatefulWidget {
  const CategoryEditPage({super.key});

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryEditCubit>().loadExisting();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.delete_rounded,
      title: context.l10n.categoryDeleteConfirmTitle,
      description: context.l10n.categoryDeleteConfirmDesc,
      cancelLabel: context.l10n.commonCancel,
      confirmLabel: context.l10n.commonDelete,
    );
    if (confirmed && context.mounted) {
      context.read<CategoryEditCubit>().delete();
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
          BlocListener<CategoryEditCubit, CategoryEditState>(
            listenWhen: (previous, current) => !previous.saved && current.saved,
            listener: (context, state) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                context,
                state.isEditing
                    ? context.l10n.categoryUpdatedSnackbar
                    : context.l10n.categoryCreatedSnackbar,
              );
            },
          ),
          BlocListener<CategoryEditCubit, CategoryEditState>(
            listenWhen: (previous, current) =>
                !previous.deleted && current.deleted,
            listener: (context, state) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(
                  context, context.l10n.categoryDeletedSnackbar);
            },
          ),
          BlocListener<CategoryEditCubit, CategoryEditState>(
            listenWhen: (previous, current) =>
                current.errorMessage != null &&
                current.errorMessage != previous.errorMessage,
            listener: (context, state) =>
                AppSnackbar.showError(context, state.errorMessage!),
          ),
        ],
        child: Scaffold(
          backgroundColor: colors.background,
          body: BlocBuilder<CategoryEditCubit, CategoryEditState>(
            builder: (context, state) {
              final cubit = context.read<CategoryEditCubit>();
              final previewColor = categoryColorFromHex(state.colorHex);

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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg, vertical: 22),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.card),
                                border: Border.all(color: colors.border),
                                boxShadow: AppShadow.card,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 64,
                                    width: 64,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          previewColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Icon(categoryIconFor(state.iconName),
                                        size: 32, color: previewColor),
                                  ),
                                  const SizedBox(height: AppSpacing.smMd),
                                  Text(
                                    state.trimmedName.isEmpty
                                        ? context
                                            .l10n.categoryPreviewPlaceholder
                                        : state.trimmedName,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    context.l10n.categoryPreviewLabel,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: colors.textTertiary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(context.l10n.categoryNameLabel,
                                style: _fieldLabelStyle(colors)),
                            const SizedBox(height: AppSpacing.xs),
                            Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: state.hasDuplicateName
                                      ? colors.danger
                                      : colors.border,
                                  width: state.hasDuplicateName ? 1.5 : 1,
                                ),
                              ),
                              child: _NameField(
                                name: state.name,
                                hintText: context.l10n.categoryNameHint,
                                onChanged: cubit.setName,
                              ),
                            ),
                            if (state.hasDuplicateName) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.error_rounded,
                                      size: 14, color: colors.danger),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      context.l10n.categoryNameDuplicateError,
                                      style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: colors.danger),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: AppSpacing.lg),
                            Text(context.l10n.categoryColorLabel,
                                style: _fieldLabelStyle(colors)),
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                for (final hex in categoryColorOptions) ...[
                                  _ColorSwatch(
                                    hex: hex,
                                    selected: state.colorHex == hex,
                                    onTap: () => cubit.setColor(hex),
                                  ),
                                  if (hex != categoryColorOptions.last)
                                    const SizedBox(width: 10),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.l10n.categoryIconLabel,
                                    style: _fieldLabelStyle(colors)
                                        .copyWith(height: 1)),
                                Text(
                                  context.l10n.categoryIconCountLabel(
                                      (categoryIconGroups[state.iconGroup] ??
                                              [])
                                          .length),
                                  style: TextStyle(
                                      fontSize: 11.5,
                                      color: colors.textTertiary),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            SizedBox(
                              height: 34,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (final groupKey
                                      in categoryIconGroupKeys) ...[
                                    _IconGroupChip(
                                      label: _groupLabel(context, groupKey),
                                      selected: state.iconGroup == groupKey,
                                      onTap: () => cubit.setIconGroup(groupKey),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.smMd),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.card),
                                border: Border.all(color: colors.border),
                                boxShadow: AppShadow.card,
                              ),
                              child: GridView.count(
                                padding: EdgeInsets.zero,
                                crossAxisCount: 5,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  for (final iconName
                                      in categoryIconGroups[state.iconGroup] ??
                                          [])
                                    _IconOption(
                                      iconName: iconName,
                                      selected: state.iconName == iconName,
                                      color: previewColor,
                                      onTap: () => cubit.setIcon(iconName),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            AppButton(
                              label: state.isEditing
                                  ? context.l10n.categorySaveButtonUpdate
                                  : context.l10n.categorySaveButtonCreate,
                              isLoading: state.isSaving,
                              onPressed: state.isValid ? cubit.save : null,
                            ),
                            if (state.isEditing && !state.isDefault) ...[
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
                                    context.l10n.categoryDeleteButton,
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
                      title: state.isEditing
                          ? context.l10n.categoryEditPageTitleEdit
                          : context.l10n.categoryEditPageTitleCreate,
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

  TextStyle _fieldLabelStyle(AppColorsExtension colors) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: colors.textSecondary,
      );

  String _groupLabel(BuildContext context, String key) => switch (key) {
        'food' => context.l10n.categoryIconGroupFood,
        'shopping' => context.l10n.categoryIconGroupShopping,
        'transport' => context.l10n.categoryIconGroupTransport,
        'home' => context.l10n.categoryIconGroupHome,
        _ => context.l10n.categoryIconGroupOther,
      };
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(
      {required this.hex, required this.selected, required this.onTap});

  final String hex;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = categoryColorFromHex(hex);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        height: 44,
        width: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected ? Border.all(color: colors.surface, width: 3) : null,
          boxShadow: selected
              ? [BoxShadow(color: color, spreadRadius: 2, blurRadius: 0)]
              : null,
        ),
        child: selected
            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}

class _IconGroupChip extends StatelessWidget {
  const _IconGroupChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.primaryTint : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: selected ? colors.primary : colors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.iconName,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String iconName;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : colors.border,
            width: selected ? 2 : 1,
          ),
          color: selected ? color.withValues(alpha: 0.1) : colors.surfaceAlt,
        ),
        child: Icon(categoryIconFor(iconName),
            size: 21, color: selected ? color : colors.textSecondary),
      ),
    );
  }
}

class _NameField extends StatefulWidget {
  const _NameField({
    required this.name,
    required this.hintText,
    required this.onChanged,
  });

  /// Current name from the cubit — may change externally (rare, but keeps
  /// this consistent with the codebase's controller-sync pattern).
  final String name;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  late final _controller = TextEditingController(text: widget.name);

  @override
  void didUpdateWidget(covariant _NameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.name != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.name,
        selection: TextSelection.collapsed(offset: widget.name.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: TextStyle(fontSize: 14, color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 14, color: colors.textTertiary),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        isCollapsed: true,
      ),
    );
  }
}
