import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/shared/components/toggles/app_toggle_switch.dart';
import 'package:spendly_app/features/notification/presentation/viewmodel/notification_center_cubit.dart';
import 'package:spendly_app/features/notification/presentation/viewmodel/notification_center_state.dart';
import 'package:spendly_app/features/notification/presentation/widgets/notification_row.dart';

const _kReminderTimeOptions = ['08:00', '12:00', '20:00'];

/// Screen 10d — reached from Profile → "Thông báo & Nhắc nhở". Recent
/// notifications list + reminder-setting toggles, per design handoff.
class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() =>
      _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCenterCubit>().load();
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
                        context.read<NotificationCenterCubit>().load(),
                    child:
                        BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
                      builder: (context, state) {
                        return switch (state) {
                          NotificationCenterLoading() => ListView(
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
                          NotificationCenterError(:final message) => ListView(
                              padding: EdgeInsets.zero,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                AppErrorView(
                                  message: message,
                                  onRetry: () =>
                                      context.read<NotificationCenterCubit>().load(),
                                ),
                              ],
                            ),
                          NotificationCenterLoaded(
                            :final notifications,
                            :final settings
                          ) =>
                            ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.screenHorizontal,
                                vertical: AppSpacing.mdLg,
                              ),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context
                                          .l10n.notificationCenterRecentTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    GestureDetector(
                                      onTap: () => context
                                          .read<NotificationCenterCubit>()
                                          .markAllAsRead(),
                                      child: Text(
                                        context.l10n
                                            .notificationCenterMarkAllRead,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.smMd),
                                if (notifications.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: AppSpacing.xl),
                                    child: AppEmptyView(
                                      icon: Icons.notifications_none_rounded,
                                      message: context
                                          .l10n.notificationCenterEmptyMessage,
                                    ),
                                  )
                                else
                                  for (final n in notifications) ...[
                                    NotificationRow(notification: n),
                                    const SizedBox(height: AppSpacing.sm),
                                  ],
                                const SizedBox(height: AppSpacing.xl),
                                Text(
                                  context.l10n
                                      .notificationCenterReminderSettingsTitle,
                                  style:
                                      Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: AppSpacing.smMd),
                                Container(
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.card),
                                    border: Border.all(color: colors.border),
                                    boxShadow: AppShadow.card,
                                  ),
                                  child: Column(
                                    children: [
                                      _ReminderToggleRow(
                                        label: context.l10n
                                            .notificationReminderDailyExpenseLabel,
                                        description: context.l10n
                                            .notificationReminderDailyExpenseDesc,
                                        value: settings.dailyExpenseReminder,
                                        onChanged: () => context
                                            .read<NotificationCenterCubit>()
                                            .toggleDailyExpenseReminder(),
                                        showTopBorder: false,
                                      ),
                                      _ReminderToggleRow(
                                        label: context.l10n
                                            .notificationReminderBudgetAlertLabel,
                                        description: context.l10n
                                            .notificationReminderBudgetAlertDesc,
                                        value: settings.budgetAlertReminder,
                                        onChanged: () => context
                                            .read<NotificationCenterCubit>()
                                            .toggleBudgetAlertReminder(),
                                      ),
                                      _ReminderToggleRow(
                                        label: context.l10n
                                            .notificationReminderRecurringAlertLabel,
                                        description: context.l10n
                                            .notificationReminderRecurringAlertDesc,
                                        value:
                                            settings.recurringAlertReminder,
                                        onChanged: () => context
                                            .read<NotificationCenterCubit>()
                                            .toggleRecurringAlertReminder(),
                                      ),
                                    ],
                                  ),
                                ),
                                if (settings.dailyExpenseReminder) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Container(
                                    padding:
                                        const EdgeInsets.all(AppSpacing.mdLg),
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.card),
                                      border:
                                          Border.all(color: colors.border),
                                      boxShadow: AppShadow.card,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          context.l10n
                                              .notificationDailyReminderTimeLabel,
                                          style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          children: [
                                            for (final time
                                                in _kReminderTimeOptions) ...[
                                              _TimeChip(
                                                label: time,
                                                selected: settings
                                                        .dailyReminderTime ==
                                                    time,
                                                onTap: () => context
                                                    .read<
                                                        NotificationCenterCubit>()
                                                    .selectDailyReminderTime(
                                                        time),
                                              ),
                                              if (time !=
                                                  _kReminderTimeOptions.last)
                                                const SizedBox(width: 6),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
                title: context.l10n.notificationCenterPageTitle,
                titleFontSize: 18,
                onBack: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderToggleRow extends StatelessWidget {
  const _ReminderToggleRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    this.showTopBorder = true,
  });

  final String label;
  final String description;
  final bool value;
  final VoidCallback onChanged;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.mdLg, vertical: 13),
      decoration: BoxDecoration(
        border: showTopBorder
            ? Border(top: BorderSide(color: colors.border))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
                ),
              ],
            ),
          ),
          AppToggleSwitch(value: value, onTap: onChanged),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? colors.primaryTint : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
              color: selected ? colors.primary : colors.border, width: 1.5),
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
