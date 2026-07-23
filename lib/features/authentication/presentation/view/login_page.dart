import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/buttons/app_button.dart';
import '../../../../shared/components/textfields/app_text_field.dart';
import '../viewmodel/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _submitting = false;
  bool _googleSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailLogin() async {
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final error = await context.read<AuthCubit>().signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _errorText = error;
    });
  }

  Future<void> _submitGoogleLogin() async {
    setState(() => _googleSubmitting = true);
    await context.read<AuthCubit>().signInWithGoogle();
    if (!mounted) return;
    setState(() => _googleSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.authHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56),
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(Icons.savings_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: AppSpacing.mdLg),
              Text('Chào bạn trở lại', style: textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(
                'Đăng nhập để tiếp tục quản lý chi tiêu',
                style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl2),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _googleSubmitting ? null : _submitGoogleLogin,
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
                            valueColor: AlwaysStoppedAnimation(colors.primary),
                          ),
                        )
                      : const Icon(Icons.g_mobiledata_rounded, size: 24),
                  label: Text('Tiếp tục với Google', style: textTheme.titleSmall),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(child: Divider(color: colors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd),
                    child: Text('hoặc', style: textTheme.bodySmall),
                  ),
                  Expanded(child: Divider(color: colors.border)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                hintText: 'you@email.com',
                icon: Icons.mail_rounded,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.smMd),
              AppTextField(
                hintText: 'Mật khẩu',
                icon: Icons.lock_rounded,
                controller: _passwordController,
                obscureText: true,
                errorText: _errorText,
              ),
              const SizedBox(height: AppSpacing.smMd),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Quên mật khẩu?', style: textTheme.labelLarge),
                ),
              ),
              const SizedBox(height: AppSpacing.xl2),
              AppButton(
                label: 'Đăng nhập',
                isLoading: _submitting,
                onPressed: _submitEmailLogin,
              ),
              const Spacer(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lgXl),
                  child: RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                      children: [
                        const TextSpan(text: 'Chưa có tài khoản? '),
                        TextSpan(
                          text: 'Đăng ký',
                          style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700),
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
    );
  }
}
