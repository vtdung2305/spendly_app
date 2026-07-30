import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/verify_otp_args.dart';

const _kOtpLength = 6;
const _kOtpExpirySeconds = 5 * 60;

/// Screen 3b — enter the 6-digit email OTP after register, or after a login
/// attempt against an unverified account ([VerifyOtpArgs.autoResend]).
class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({required this.args, super.key});

  final VerifyOtpArgs args;

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _timer;
  int _secondsLeft = _kOtpExpirySeconds;
  String? _errorText;
  bool _verifying = false;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    if (widget.args.autoResend) _resendOtp(showSnackbar: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _kOtpExpirySeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  String get _countdownLabel {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _verify() async {
    setState(() {
      _verifying = true;
      _errorText = null;
    });
    final result = await context
        .read<AuthCubit>()
        .verifyOtp(widget.args.email, _codeController.text);
    if (!mounted) return;
    setState(() => _verifying = false);
    if (result.success) {
      AppSnackbar.showSuccess(context, context.l10n.verifyOtpVerifiedSnackbar);
      context.go('/dashboard');
      return;
    }
    setState(() {
      _errorText = result.errorCode == 'OTP_TOO_MANY_ATTEMPTS'
          ? context.l10n.verifyOtpTooManyAttemptsError
          : context.l10n.verifyOtpCodeInvalidError;
    });
  }

  Future<void> _resendOtp({bool showSnackbar = true}) async {
    setState(() => _resending = true);
    final error = await context.read<AuthCubit>().resendOtp(widget.args.email);
    if (!mounted) return;
    setState(() {
      _resending = false;
      _codeController.clear();
      _errorText = null;
    });
    _startCountdown();
    if (!showSnackbar) return;
    if (error != null) {
      AppSnackbar.showError(context, error);
    } else {
      AppSnackbar.showSuccess(context, context.l10n.verifyOtpResentSnackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final hasError = _errorText != null;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.authHorizontal),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 56),
                    Center(
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: const Icon(Icons.mark_email_read_rounded,
                            color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.mdLg),
                    Center(
                      child: Text(
                        context.l10n.verifyOtpTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyMedium?.copyWith(
                              color: colors.textSecondary, height: 1.5),
                          children: [
                            TextSpan(text: context.l10n.verifyOtpSubtitle),
                            const TextSpan(text: '\n'),
                            TextSpan(
                              text: widget.args.email,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    _OtpCodeInput(
                      controller: _codeController,
                      focusNode: _focusNode,
                      hasError: hasError,
                      onChanged: (_) => setState(() => _errorText = null),
                    ),
                    if (hasError) ...[
                      const SizedBox(height: AppSpacing.smMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_rounded,
                              size: 14, color: colors.danger),
                          const SizedBox(width: 5),
                          Text(
                            _errorText!,
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: colors.danger),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: AppSpacing.md),
                      Center(
                        child: Text(
                          context.l10n.verifyOtpExpiresInLabel(_countdownLabel),
                          style: AppTypography.mono(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colors.textTertiary),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lgXl),
                    AppButton(
                      label: context.l10n.verifyOtpSubmitButton,
                      isLoading: _verifying,
                      onPressed: _codeController.text.length == _kOtpLength
                          ? _verify
                          : null,
                    ),
                    const Spacer(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: TextButton(
                          onPressed: _resending ? null : () => _resendOtp(),
                          child: RichText(
                            text: TextSpan(
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: colors.textSecondary),
                              children: [
                                TextSpan(
                                    text: context.l10n.verifyOtpResendPrompt),
                                TextSpan(
                                  text: ' ${context.l10n.verifyOtpResendLink}',
                                  style: TextStyle(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lgXl),
                        child: TextButton(
                          onPressed: () => context.go('/register'),
                          child: Text(
                            context.l10n.verifyOtpChangeEmailLink,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An invisible full-size numeric [TextField] layered over 6 underline
/// cells — matches the design's `otpCells` (bottom-border box, no full
/// outline), auto-focusing on entry.
class _OtpCodeInput extends StatelessWidget {
  const _OtpCodeInput({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final code = value.text;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _kOtpLength; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    _OtpCell(
                      char: i < code.length ? code[i] : '',
                      active: code.length == i,
                      hasError: hasError,
                    ),
                  ],
                ],
              );
            },
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                showCursor: false,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_kOtpLength),
                ],
                onChanged: onChanged,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  isCollapsed: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpCell extends StatelessWidget {
  const _OtpCell(
      {required this.char, required this.active, required this.hasError});

  final String char;
  final bool active;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filled = char.isNotEmpty;
    final lineColor = hasError
        ? colors.danger
        : filled || active
            ? colors.primary
            : colors.border;
    final thick = filled || active || hasError;

    return Container(
      width: 44,
      height: 52,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: lineColor, width: thick ? 2.5 : 1.5),
        ),
      ),
      child: Text(
        char,
        style: AppTypography.mono(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: hasError ? colors.danger : colors.textPrimary,
        ),
      ),
    );
  }
}
