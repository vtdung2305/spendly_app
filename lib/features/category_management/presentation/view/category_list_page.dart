import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/bordered_icon_button.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/shared/components/borders/dashed_rrect_border.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/category_management/presentation/mappers/category_icon_ui.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_cubit.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_edit_args.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_state.dart';

/// Screen 14 — Profile → Danh mục. No bottom nav/FAB (design shows only a
/// back arrow + "+" in the header), reached via Profile's menu row.
class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().load();
  }

  Future<void> _openEditor(BuildContext context, {Category? category}) async {
    await context.push('/categories/edit',
        extra: CategoryEditArgs(editing: category));
    if (context.mounted) context.read<CategoryCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Row(
                children: [
                  BorderedIconButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(context.l10n.categoryListPageTitle,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  InkWell(
                    onTap: () => _openEditor(context),
                    borderRadius: BorderRadius.circular(100),
                    child: Icon(Icons.add_circle_rounded,
                        size: 22, color: colors.primary),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<CategoryCubit>().load(),
                  child: BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      return switch (state) {
                        CategoryLoading() => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: AppSpacing.xxl2),
                                child: AppLoadingIndicator(),
                              ),
                            ],
                          ),
                        CategoryError(:final message) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              AppErrorView(
                                message: message,
                                onRetry: () =>
                                    context.read<CategoryCubit>().load(),
                              ),
                            ],
                          ),
                        CategoryLoaded(categories: []) => LayoutBuilder(
                            builder: (context, constraints) => ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight - 64,
                                  child: AppEmptyView(
                                    icon: Icons.category_rounded,
                                    message:
                                        context.l10n.categoryListEmptyMessage,
                                  ),
                                ),
                                _AddNewCategoryButton(
                                  onTap: () => _openEditor(context),
                                ),
                              ],
                            ),
                          ),
                        CategoryLoaded(:final categories) => ListView(
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                context.l10n
                                    .categoryCountLabel(categories.length),
                                style: TextStyle(
                                    fontSize: 12, color: colors.textSecondary),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: AppSpacing.mdLg),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: colors.surface,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.card),
                                  border: Border.all(color: colors.border),
                                  boxShadow: AppShadow.card,
                                ),
                                child: Column(
                                  children: [
                                    for (var i = 0; i < categories.length; i++)
                                      _CategoryRow(
                                        category: categories[i],
                                        showTopBorder: i > 0,
                                        onTap: () => _openEditor(context,
                                            category: categories[i]),
                                      ),
                                  ],
                                ),
                              ),
                              _AddNewCategoryButton(
                                onTap: () => _openEditor(context),
                              ),
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
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.showTopBorder,
    required this.onTap,
  });

  final Category category;
  final bool showTopBorder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = categoryColorFromHex(category.colorHex);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs, vertical: AppSpacing.smMd),
        decoration: BoxDecoration(
          border: showTopBorder
              ? Border(top: BorderSide(color: colors.border))
              : null,
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(categoryIconFor(category.iconName),
                  size: 19, color: color),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.label,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 1),
                  Text(
                    context.l10n.categoryUsageNone,
                    style: TextStyle(fontSize: 11, color: colors.textTertiary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

/// Dashed CTA — Flutter has no built-in dashed border, so it's hand-painted
/// to match the design's `border:1px dashed {{ c.primary }}`.
class _AddNewCategoryButton extends StatelessWidget {
  const _AddNewCategoryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: DashedRRectBorder(
          color: colors.primary,
          radius: 16,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryTint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 19, color: colors.primary),
                const SizedBox(width: 7),
                Text(
                  context.l10n.categoryAddNewButton,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
