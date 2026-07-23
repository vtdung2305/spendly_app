import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/add_transaction/presentation/view/add_transaction_page.dart';
import '../../features/add_transaction/presentation/viewmodel/add_transaction_cubit.dart';
import '../../features/authentication/presentation/view/login_page.dart';
import '../../features/authentication/presentation/view/register_page.dart';
import '../../features/budget/presentation/view/budget_page.dart';
import '../../features/budget/presentation/viewmodel/budget_cubit.dart';
import '../../features/calendar/presentation/view/calendar_page.dart';
import '../../features/calendar/presentation/viewmodel/calendar_cubit.dart';
import '../../features/dashboard/presentation/view/dashboard_page.dart';
import '../../features/dashboard/presentation/viewmodel/dashboard_cubit.dart';
import '../../features/income_management/presentation/view/income_page.dart';
import '../../features/income_management/presentation/viewmodel/income_cubit.dart';
import '../../features/profile/presentation/view/profile_page.dart';
import '../../features/reports/presentation/view/reports_page.dart';
import '../../features/reports/presentation/viewmodel/reports_cubit.dart';
import '../../features/settings/presentation/view/settings_page.dart';
import '../../features/splash/presentation/view/splash_page.dart';
import '../../features/transaction_history/presentation/view/history_page.dart';
import '../../features/transaction_history/presentation/viewmodel/history_cubit.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import '../di/injection.dart';

/// Typed route table — each page that needs its own ViewModel wraps itself
/// in a `BlocProvider` here so navigation always creates a fresh Cubit
/// (Dashboard/Calendar/Reports/...) while AuthCubit/ThemeCubit (app-wide) are
/// injected as the pre-existing singletons via MultiBlocProvider in main.dart.
abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => BlocProvider(
          create: (_) => DashboardCubit(getIt()),
          child: const DashboardPage(),
        ),
      ),
      GoRoute(
        path: '/add-transaction',
        builder: (context, state) {
          final initialTab = state.uri.queryParameters['type'] == 'income'
              ? TransactionType.income
              : TransactionType.expense;
          return BlocProvider(
            create: (_) => AddTransactionCubit(getIt(), initialTab: initialTab),
            child: const AddTransactionPage(),
          );
        },
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => BlocProvider(
          create: (_) => CalendarCubit(getIt()),
          child: const CalendarPage(),
        ),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => BlocProvider(
          create: (_) => ReportsCubit(getIt()),
          child: const ReportsPage(),
        ),
      ),
      GoRoute(
        path: '/budget',
        builder: (context, state) => BlocProvider(
          create: (_) => BudgetCubit(getIt()),
          child: const BudgetPage(),
        ),
      ),
      GoRoute(
        path: '/income',
        builder: (context, state) => BlocProvider(
          create: (_) => IncomeCubit(getIt()),
          child: const IncomePage(),
        ),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => BlocProvider(
          create: (_) => HistoryCubit(getIt()),
          child: const HistoryPage(),
        ),
      ),
      GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
    ],
  );
}
