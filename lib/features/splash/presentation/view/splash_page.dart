import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/locale/locale_cubit.dart';
import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_state.dart';
import 'package:spendly_app/features/splash/presentation/widgets/pulsing_dots.dart';

/// Brand moment while Supabase session/auth state resolves. Auto-navigates
/// to Login/Dashboard once [AuthCubit] resolves [AuthState] — this page
/// itself has no domain layer, it just reacts to the shared auth session.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final needsLanguageSelect = context.read<LocaleCubit>().state == null;
        switch (state) {
          case AuthAuthenticated():
            context.go(needsLanguageSelect ? '/language-select' : '/dashboard');
          case AuthUnauthenticated():
            context.go(needsLanguageSelect ? '/language-select' : '/login');
          case AuthCheckFailed():
          case AuthOffline():
          case AuthInitial():
            break;
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.splashEnd],
            ),
          ),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 84,
                      width: 84,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.savings_rounded,
                          color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      context.l10n.splashAppName,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.splashTagline,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.75)),
                    ),
                    const SizedBox(height: 18),
                    switch (state) {
                      AuthCheckFailed() => _SplashRetry(
                          icon: Icons.error,
                          message: context.l10n.splashServerErrorMessage,
                        ),
                      AuthOffline() => _SplashRetry(
                          icon: Icons.wifi_off,
                          message: context.l10n.splashOfflineMessage,
                        ),
                      _ => const PulsingDots(),
                    },
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Error/Offline footer — icon + fixed copy + "Thử lại" retry button, shown
/// in place of [PulsingDots] once [AuthCubit.checkSession] resolves to a
/// non-loading failure state.
class _SplashRetry extends StatelessWidget {
  const _SplashRetry({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.white),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13, color: Colors.white.withValues(alpha: 0.85)),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => context.read<AuthCubit>().checkSession(),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.16),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(context.l10n.commonRetry,
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
