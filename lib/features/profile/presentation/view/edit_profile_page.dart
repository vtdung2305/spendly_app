import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_state.dart';

/// Screen 12b in the design handoff — full-screen push from the Profile
/// card's edit icon. Họ/Tên/Phone/Email are required; Address is the only
/// optional field, per `saveProfileDisabled` in the design's prototype JS.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    for (final controller in [
      _firstNameController,
      _lastNameController,
      _phoneController,
      _emailController,
    ]) {
      controller.addListener(_refresh);
    }
  }

  void _refresh() => setState(() {});

  bool get _isValid =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final error = await context.read<AuthCubit>().updateProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          address: _addressController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (error != null) {
      AppSnackbar.showError(context, error);
      return;
    }
    Navigator.of(context).pop();
    AppSnackbar.showSuccess(context, context.l10n.editProfileUpdatedSnackbar);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Row(
                children: [
                  _CloseButton(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: AppSpacing.md),
                  Text(context.l10n.editProfilePageTitle,
                      style: textTheme.titleMedium),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: _AvatarPicker(
                        initial: _avatarInitial(),
                        onTapCamera: () => AppSnackbar.showInfo(
                          context,
                          context.l10n.editProfileAvatarChangeLabel,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _FormField(
                      label: context.l10n.editProfileFirstNameLabel,
                      controller: _firstNameController,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: context.l10n.editProfileLastNameLabel,
                      controller: _lastNameController,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: context.l10n.editProfilePhoneLabel,
                      controller: _phoneController,
                      hint: context.l10n.editProfilePhoneHint,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: context.l10n.editProfileEmailLabel,
                      controller: _emailController,
                      hint: context.l10n.editProfileEmailHint,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: context.l10n.editProfileAddressLabel,
                      controller: _addressController,
                      hint: context.l10n.editProfileAddressHint,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.mdLg),
                child: AppButton(
                  label: context.l10n.editProfileSaveButton,
                  isLoading: _isSaving,
                  onPressed: _isValid ? _save : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _avatarInitial() {
    final lastNameTokens =
        _lastNameController.text.trim().split(RegExp(r'\s+'));
    final lastToken = lastNameTokens.isNotEmpty ? lastNameTokens.last : '';
    if (lastToken.isNotEmpty) return lastToken.substring(0, 1).toUpperCase();
    final firstNameTokens =
        _firstNameController.text.trim().split(RegExp(r'\s+'));
    final firstToken = firstNameTokens.isNotEmpty ? firstNameTokens.first : '';
    return firstToken.isNotEmpty
        ? firstToken.substring(0, 1).toUpperCase()
        : 'U';
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(color: colors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: SizedBox(
          height: 38,
          width: 38,
          child: Icon(Icons.close_rounded, size: 20, color: colors.textPrimary),
        ),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({required this.initial, required this.onTapCamera});
  final String initial;
  final VoidCallback onTapCamera;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        SizedBox(
          height: 84,
          width: 84,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 84,
                width: 84,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: colors.primary, shape: BoxShape.circle),
                child: Text(
                  initial,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onTapCamera,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.background, width: 2),
                    ),
                    child: const Icon(Icons.photo_camera_rounded,
                        size: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTapCamera,
          child: Text(
            context.l10n.editProfileAvatarChangeLabel,
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: colors.primary),
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
