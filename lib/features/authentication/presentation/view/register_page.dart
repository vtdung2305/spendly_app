import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/textfields/app_text_field.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
    final error = await context.read<AuthCubit>().registerWithEmail(
          _emailController.text,
          _passwordController.text,
          _confirmPasswordController.text,
        );
    if (!mounted) return;
    // Client-side validation errors are field-specific and shown inline
    // under the relevant field; anything else (server/network) isn't tied
    // to one field, so it goes to a snackbar instead.
    final isConfirmError = error != null && error.contains('xác nhận');
    final isPasswordError =
        error != null && !isConfirmError && error.contains('Mật khẩu');
    final isEmailError = error != null && error.contains('Email');
    setState(() {
      _submitting = false;
      _emailError = isEmailError ? error : null;
      _passwordError = isPasswordError ? error : null;
      _confirmPasswordError = isConfirmError ? error : null;
    });
    if (error == null) {
      context.go('/dashboard');
    } else if (!isEmailError && !isPasswordError && !isConfirmError) {
      AppSnackbar.showError(context, error);
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
                        context.l10n.registerTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        context.l10n.registerSubtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      context.l10n.registerEmailLabel,
                      style: textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppTextField(
                      hintText: context.l10n.registerEmailHint,
                      icon: Icons.mail_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: AppSpacing.smMd),
                    Text(
                      context.l10n.registerPasswordLabel,
                      style: textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppTextField(
                      hintText: context.l10n.registerPasswordHint,
                      icon: Icons.lock_rounded,
                      controller: _passwordController,
                      obscureText: true,
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: AppSpacing.smMd),
                    Text(
                      context.l10n.registerConfirmPasswordLabel,
                      style: textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppTextField(
                      hintText: context.l10n.registerConfirmPasswordHint,
                      icon: Icons.lock_rounded,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      errorText: _confirmPasswordError,
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    AppButton(
                      label: context.l10n.registerSubmitButton,
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
                                    text:
                                        context.l10n.registerHasAccountPrefix),
                                TextSpan(
                                  text: context.l10n.registerLoginLink,
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
