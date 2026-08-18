import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_animation.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';

class _OnboardingSlideData {
  const _OnboardingSlideData(
      {required this.icon, required this.title, required this.desc});
  final IconData icon;
  final String title;
  final String desc;
}

/// Screen 1c — shown once, right after language selection and before
/// Login/Register, per design handoff's "1c. ONBOARDING". Presentation-only,
/// same as the language-select screen that precedes it.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _step = 0;

  static const _slideCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() => context.go('/login');

  void _next() {
    if (_step >= _slideCount - 1) {
      _goToLogin();
    } else {
      _pageController.nextPage(
          duration: AppAnimation.pageTransition, curve: Curves.easeOut);
    }
  }

  void _goToStep(int step) {
    _pageController.animateToPage(step,
        duration: AppAnimation.pageTransition, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final slides = [
      _OnboardingSlideData(
        icon: Icons.travel_explore_rounded,
        title: l10n.onboardingSlide1Title,
        desc: l10n.onboardingSlide1Desc,
      ),
      _OnboardingSlideData(
        icon: Icons.donut_large_rounded,
        title: l10n.onboardingSlide2Title,
        desc: l10n.onboardingSlide2Desc,
      ),
      _OnboardingSlideData(
        icon: Icons.savings_rounded,
        title: l10n.onboardingSlide3Title,
        desc: l10n.onboardingSlide3Desc,
      ),
    ];
    final isLastStep = _step >= slides.length - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.splashEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: AppSpacing.lgXl, top: AppSpacing.sm),
                  child: InkWell(
                    onTap: _goToLogin,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.smMd, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        l10n.onboardingSkipButton,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  onPageChanged: (step) => setState(() => _step = step),
                  itemBuilder: (context, index) =>
                      _OnboardingSlide(data: slides[index]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lgXl, 0, AppSpacing.lgXl, AppSpacing.xxl2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < slides.length; i++)
                          _OnboardingDot(
                            active: i == _step,
                            onTap: () => _goToStep(i),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lgXl),
                    AppButton(
                      label: isLastStep
                          ? l10n.onboardingStartButton
                          : l10n.onboardingContinueButton,
                      backgroundColor: Colors.white,
                      foregroundColor: colors.primary,
                      onPressed: _next,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data});

  final _OnboardingSlideData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.card + 12),
            ),
            child: Icon(data.icon, size: 56, color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xxl2),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.2),
          ),
          const SizedBox(height: AppSpacing.smMd),
          Text(
            data.desc,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

class _OnboardingDot extends StatelessWidget {
  const _OnboardingDot({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: AnimatedContainer(
          duration: AppAnimation.fast,
          height: 8,
          width: active ? 24 : 8,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ),
    );
  }
}
