import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../authentication/presentation/viewmodel/auth_cubit.dart';
import '../../../authentication/presentation/viewmodel/auth_state.dart';
import '../widgets/pulsing_dots.dart';

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
        switch (state) {
          case AuthAuthenticated():
            context.go('/dashboard');
          case AuthUnauthenticated():
            context.go('/login');
          case AuthCheckFailed():
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
                      child: const Icon(Icons.savings_rounded, color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Spendly',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Quản lý chi tiêu thông minh',
                      style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.75)),
                    ),
                    const SizedBox(height: 18),
                    if (state is AuthCheckFailed)
                      Column(
                        children: [
                          Text(
                            state.message,
                            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.85)),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => context.read<AuthCubit>().checkSession(),
                            child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    else
                      const PulsingDots(),
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
