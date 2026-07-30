import 'package:flutter/gestures.dart';
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
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_state.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/verify_otp_args.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _submitting = false;
  bool _googleSubmitting = false;
  bool _facebookSubmitting = false;

  Future<void> _submitFacebookLogin() async {
    setState(() => _facebookSubmitting = true);
    final cubit = context.read<AuthCubit>();
    final error = await cubit.signInWithFacebook();
    if (!mounted) return;
    setState(() => _facebookSubmitting = false);
    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
    } else if (cubit.state is AuthAuthenticated) {
      context.go('/dashboard');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailLogin() async {
    setState(() {
      _submitting = true;
      _emailError = null;
      _passwordError = null;
    });
    final result = await context.read<AuthCubit>().signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
    if (!mounted) return;
    if (result.otpEmail != null) {
      setState(() => _submitting = false);
      context.push('/verify-otp',
          extra: VerifyOtpArgs(email: result.otpEmail!, autoResend: true));
      return;
    }
    final error = result.errorMessage;
    setState(() {
      _submitting = false;
      // Client-side validation errors are field-specific ("Email không hợp
      // lệ" / "Mật khẩu phải có ít nhất 6 ký tự") and shown inline under the
      // relevant field; anything else (wrong credentials, network, server)
      // isn't tied to one field, so it goes to a snackbar instead.
      _emailError = error != null && error.contains('Email') ? error : null;
      _passwordError =
          error != null && error.contains('Mật khẩu') ? error : null;
    });
    if (result.success) {
      context.go('/dashboard');
    } else if (_emailError == null && _passwordError == null) {
      AppSnackbar.showError(context, error!);
    }
  }

  Future<void> _submitGoogleLogin() async {
    setState(() => _googleSubmitting = true);
    final cubit = context.read<AuthCubit>();
    final error = await cubit.signInWithGoogle();
    if (!mounted) return;
    setState(() => _googleSubmitting = false);
    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
    } else if (cubit.state is AuthAuthenticated) {
      // A null error can also mean the user simply cancelled the native
      // picker — only navigate on an actual successful sign-in.
      context.go('/dashboard');
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
                        context.l10n.loginTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        context.l10n.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl2),
                    Text(
                      context.l10n.loginEmailLabel,
                      style: textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppTextField(
                      hintText: context.l10n.loginEmailHint,
                      icon: Icons.mail_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: AppSpacing.smMd),
                    Text(
                      context.l10n.loginPasswordLabel,
                      style: textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppTextField(
                      hintText: context.l10n.loginPasswordHint,
                      icon: Icons.lock_rounded,
                      controller: _passwordController,
                      obscureText: true,
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: AppSpacing.smMd),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: Text(context.l10n.loginForgotPasswordLink,
                            style: textTheme.labelLarge),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    AppButton(
                      label: context.l10n.loginSubmitButton,
                      isLoading: _submitting,
                      onPressed: _submitEmailLogin,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(child: Divider(color: colors.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.smMd),
                          child: Text(context.l10n.loginOrDivider,
                              style: textTheme.bodySmall),
                        ),
                        Expanded(child: Divider(color: colors.border)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed:
                            _googleSubmitting ? null : _submitGoogleLogin,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                        icon: _googleSubmitting
                            ? SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(colors.primary),
                                ),
                              )
                            : const Icon(Icons.g_mobiledata_rounded, size: 24),
                        label: Text(context.l10n.loginContinueWithGoogleButton,
                            style: textTheme.titleSmall),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.smMd),
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            _facebookSubmitting ? null : _submitFacebookLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877F2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          elevation: 0,
                        ),
                        icon: _facebookSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Icon(Icons.facebook,
                                size: 22, color: Colors.white),
                        label: Text(
                          context.l10n.loginContinueWithFacebookButton,
                          style: textTheme.titleSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lgXl),
                        child: RichText(
                          text: TextSpan(
                            style: textTheme.bodyMedium
                                ?.copyWith(color: colors.textSecondary),
                            children: [
                              TextSpan(text: context.l10n.loginNoAccountPrefix),
                              TextSpan(
                                text: context.l10n.loginRegisterLink,
                                style: TextStyle(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w700),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.push('/register'),
                              ),
                            ],
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
