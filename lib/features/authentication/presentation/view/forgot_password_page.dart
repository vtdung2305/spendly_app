import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/textfields/app_text_field.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';

/// Screen 3b — recover access via email reset link. Same centered icon-tile
/// header as Login/Register (no back button); submit shows a confirmation
/// snackbar and returns to Login.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? _errorText;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final error = await context
        .read<AuthCubit>()
        .sendPasswordResetEmail(_emailController.text);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _errorText = error;
    });
    if (error == null) {
      AppSnackbar.showSuccess(
          context, context.l10n.forgotPasswordSuccessSnackbar);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

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
                        child: const Icon(Icons.savings_rounded,
                            color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.mdLg),
                    Center(
                      child: Text(
                        context.l10n.forgotPasswordTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        context.l10n.forgotPasswordSubtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      context.l10n.forgotPasswordEmailLabel,
                      style: textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppTextField(
                      hintText: context.l10n.forgotPasswordEmailHint,
                      icon: Icons.mail_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _errorText,
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    AppButton(
                      label: context.l10n.forgotPasswordSubmitButton,
                      isLoading: _submitting,
                      onPressed: _submit,
                    ),
                    const Spacer(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lgXl),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: RichText(
                            text: TextSpan(
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: colors.textSecondary),
                              children: [
                                TextSpan(
                                    text: context
                                        .l10n.forgotPasswordRememberedPrefix),
                                TextSpan(
                                  text: context.l10n.forgotPasswordLoginLink,
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
