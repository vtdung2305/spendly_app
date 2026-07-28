import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/banners/alert_banner.dart';
import 'package:spendly_app/shared/components/buttons/bordered_icon_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_confirm_dialog.dart';
import 'package:spendly_app/shared/components/notifications/notification_center_row.dart';

/// Screen 14 — component catalog cataloging every notification/feedback
/// pattern used across the app, for consistent implementation. Not a
/// user-facing flow: every section is a static preview (matching the real
/// in-app styling), not a live trigger — per design handoff.
class FeedbackKitPage extends StatelessWidget {
  const FeedbackKitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.mdLg,
                AppSpacing.screenHorizontal,
                0,
              ),
              child: Row(
                children: [
                  BorderedIconButton(
                    icon: Icons.close_rounded,
                    onPressed: () => context.go('/dashboard'),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(context.l10n.feedbackKitPageTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                children: [
                  _Section(
                    title: context.l10n.feedbackKitPushNotificationSection,
                    child: const _PushNotificationPreview(),
                  ),
                  _Section(
                    title: context.l10n.feedbackKitSnackbarSection,
                    child: Column(
                      children: [
                        _TogglePill(
                          icon: Icons.check_circle_rounded,
                          iconColor: colors.success,
                          text: context.l10n.feedbackKitSnackbarSuccess,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _TogglePill(
                          icon: Icons.error_rounded,
                          iconColor: colors.danger,
                          text: context.l10n.feedbackKitSnackbarError,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _TogglePill(
                          icon: Icons.warning_rounded,
                          iconColor: colors.warning,
                          text: context.l10n.feedbackKitSnackbarWarning,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _TogglePill(
                          icon: Icons.info_rounded,
                          iconColor: colors.primary,
                          text: context.l10n.feedbackKitSnackbarInfo,
                        ),
                      ],
                    ),
                  ),
                  _Section(
                    title: context.l10n.feedbackKitAlertBannerSection,
                    child: Column(
                      children: [
                        AlertBanner(
                          variant: AlertBannerVariant.success,
                          title:
                              context.l10n.feedbackKitAlertBannerSuccessTitle,
                          description:
                              context.l10n.feedbackKitAlertBannerSuccessDesc,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AlertBanner(
                          variant: AlertBannerVariant.error,
                          title: context.l10n.feedbackKitAlertBannerErrorTitle,
                          description:
                              context.l10n.feedbackKitAlertBannerErrorDesc,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AlertBanner(
                          variant: AlertBannerVariant.warning,
                          title:
                              context.l10n.feedbackKitAlertBannerWarningTitle,
                          description:
                              context.l10n.feedbackKitAlertBannerWarningDesc,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AlertBanner(
                          variant: AlertBannerVariant.info,
                          title: context.l10n.feedbackKitAlertBannerInfoTitle,
                          description:
                              context.l10n.feedbackKitAlertBannerInfoDesc,
                        ),
                      ],
                    ),
                  ),
                  _Section(
                    title: context.l10n.feedbackKitValidationSection,
                    child: Column(
                      children: [
                        _ValidationField(
                          label: context.l10n.feedbackKitValidationAmountLabel,
                          value: context.l10n.feedbackKitValidationAmountValue,
                          isError: true,
                          icon: Icons.error_rounded,
                          message:
                              context.l10n.feedbackKitValidationAmountError,
                        ),
                        const SizedBox(height: AppSpacing.mdLg),
                        _ValidationField(
                          label: context.l10n.feedbackKitValidationEmailLabel,
                          value: context.l10n.feedbackKitValidationEmailValue,
                          isError: false,
                          icon: Icons.check_circle_rounded,
                          message:
                              context.l10n.feedbackKitValidationEmailSuccess,
                        ),
                      ],
                    ),
                  ),
                  _Section(
                    title: context.l10n.feedbackKitConfirmDialogSection,
                    child: AppConfirmDialog(
                      icon: Icons.delete_rounded,
                      title: context.l10n.calendarDeleteConfirmTitle,
                      description: context.l10n.feedbackKitConfirmDialogDesc,
                      cancelLabel: context.l10n.commonCancel,
                      confirmLabel: context.l10n.commonDelete,
                    ),
                  ),
                  _Section(
                    title: context.l10n.feedbackKitNotificationCenterSection,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: colors.border),
                        boxShadow: AppShadow.card,
                      ),
                      child: Column(
                        children: [
                          NotificationCenterRow(
                            icon: Icons.account_balance_wallet_rounded,
                            title: context
                                .l10n.feedbackKitNotificationCenterItem1Title,
                            timestamp: context
                                .l10n.feedbackKitNotificationCenterItem1Time,
                            unread: true,
                          ),
                          NotificationCenterRow(
                            icon: Icons.receipt_long_rounded,
                            title: context
                                .l10n.feedbackKitNotificationCenterItem2Title,
                            timestamp: context
                                .l10n.feedbackKitNotificationCenterItem2Time,
                            showTopDivider: true,
                          ),
                          NotificationCenterRow(
                            icon: Icons.cloud_done_rounded,
                            title: context
                                .l10n.feedbackKitNotificationCenterItem3Title,
                            timestamp: context
                                .l10n.feedbackKitNotificationCenterItem3Time,
                            showTopDivider: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _Section(
                    title: context.l10n.feedbackKitButtonStatesSection,
                    isLast: true,
                    child: Column(
                      children: [
                        _StateButton(
                            label: context.l10n.addTransactionSaveButton,
                            color: colors.primary),
                        const SizedBox(height: AppSpacing.sm),
                        _StateButton(
                          label: context.l10n.feedbackKitButtonLoading,
                          color: colors.primary,
                          opacity: 0.7,
                          icon: Icons.refresh_rounded,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _StateButton(
                          label: context.l10n.feedbackKitButtonSuccess,
                          color: colors.success,
                          icon: Icons.check_circle_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(
      {required this.title, required this.child, this.isLast = false});
  final String title;
  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.cardGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.textTertiary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}

class _PushNotificationPreview extends StatelessWidget {
  const _PushNotificationPreview();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
                color: colors.primary, borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.savings_rounded,
                color: Colors.white, size: 17),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.feedbackKitPushAppName.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                    ),
                    Text(
                      context.l10n.feedbackKitPushTimestamp,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(context.l10n.feedbackKitPushTitle,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  context.l10n.feedbackKitPushBody,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill(
      {required this.icon, required this.iconColor, required this.text});

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.smMd),
      decoration: BoxDecoration(
        color: colors.textPrimary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidationField extends StatelessWidget {
  const _ValidationField({
    required this.label,
    required this.value,
    required this.isError,
    required this.icon,
    required this.message,
  });

  final String label;
  final String value;
  final bool isError;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final stateColor = isError ? colors.danger : colors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: stateColor, width: 1.5),
          ),
          child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(icon, size: 14, color: stateColor),
            const SizedBox(width: 5),
            Text(
              message,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: stateColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.5),
            ),
          ],
        ),
      ],
    );
  }
}

class _StateButton extends StatelessWidget {
  const _StateButton(
      {required this.label,
      required this.color,
      this.opacity = 1.0,
      this.icon});

  final String label;
  final Color color;
  final double opacity;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: Colors.white),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
