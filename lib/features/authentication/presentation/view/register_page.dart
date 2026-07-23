import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/buttons/app_button.dart';
import '../../../../shared/components/buttons/bordered_icon_button.dart';
import '../../../../shared/components/textfields/app_text_field.dart';
import '../viewmodel/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorText;
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
      _errorText = null;
    });
    final error = await context.read<AuthCubit>().registerWithEmail(
          _emailController.text,
          _passwordController.text,
          _confirmPasswordController.text,
        );
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _errorText = error;
    });
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
              const SizedBox(height: AppSpacing.xxl2),
              BorderedIconButton(
                icon: Icons.arrow_back_rounded,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: AppSpacing.xl2),
              Text('Tạo tài khoản', style: textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(
                'Bắt đầu quản lý tài chính của bạn',
                style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
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
              ),
              const SizedBox(height: AppSpacing.smMd),
              AppTextField(
                hintText: 'Xác nhận mật khẩu',
                icon: Icons.lock_rounded,
                controller: _confirmPasswordController,
                obscureText: true,
                errorText: _errorText,
              ),
              const SizedBox(height: AppSpacing.xl2),
              AppButton(
                label: 'Đăng ký',
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
                        style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                        children: [
                          const TextSpan(text: 'Đã có tài khoản? '),
                          TextSpan(
                            text: 'Đăng nhập',
                            style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700),
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
    );
  }
}
