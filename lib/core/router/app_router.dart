import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/features/add_transaction/presentation/view/add_transaction_page.dart';
import 'package:spendly_app/features/add_transaction/presentation/viewmodel/add_transaction_cubit.dart';
import 'package:spendly_app/features/authentication/presentation/view/forgot_password_page.dart';
import 'package:spendly_app/features/authentication/presentation/view/login_page.dart';
import 'package:spendly_app/features/authentication/presentation/view/register_page.dart';
import 'package:spendly_app/features/authentication/presentation/view/verify_otp_page.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/verify_otp_args.dart';
import 'package:spendly_app/features/budget/presentation/view/add_budget_page.dart';
import 'package:spendly_app/features/budget/presentation/view/budget_page.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/presentation/view/edit_budget_page.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/add_budget_cubit.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/budget_cubit.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/edit_budget_cubit.dart';
import 'package:spendly_app/features/calendar/presentation/view/calendar_page.dart';
import 'package:spendly_app/features/calendar/presentation/viewmodel/calendar_cubit.dart';
import 'package:spendly_app/features/category_management/presentation/view/category_edit_page.dart';
import 'package:spendly_app/features/category_management/presentation/view/category_list_page.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_cubit.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_edit_args.dart';
import 'package:spendly_app/features/category_management/presentation/viewmodel/category_edit_cubit.dart';
import 'package:spendly_app/features/dashboard/presentation/view/dashboard_page.dart';
import 'package:spendly_app/features/dashboard/presentation/viewmodel/dashboard_cubit.dart';
import 'package:spendly_app/features/feedback_kit/presentation/view/feedback_kit_page.dart';
import 'package:spendly_app/features/income_management/presentation/view/income_page.dart';
import 'package:spendly_app/features/income_management/presentation/viewmodel/income_cubit.dart';
import 'package:spendly_app/features/language/presentation/view/language_select_page.dart';
import 'package:spendly_app/features/profile/presentation/view/edit_profile_page.dart';
import 'package:spendly_app/features/profile/presentation/view/profile_page.dart';
import 'package:spendly_app/features/notification/presentation/view/notification_center_page.dart';
import 'package:spendly_app/features/notification/presentation/viewmodel/notification_center_cubit.dart';
import 'package:spendly_app/features/onboarding/presentation/view/onboarding_page.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/view/recurring_transaction_form_page.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/view/recurring_transaction_list_page.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/viewmodel/recurring_transaction_form_cubit.dart';
import 'package:spendly_app/features/recurring_transaction/presentation/viewmodel/recurring_transaction_list_cubit.dart';
import 'package:spendly_app/features/reports/presentation/view/reports_page.dart';
import 'package:spendly_app/features/reports/presentation/viewmodel/reports_cubit.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/presentation/view/savings_goal_detail_page.dart';
import 'package:spendly_app/features/savings_goal/presentation/view/savings_goal_form_page.dart';
import 'package:spendly_app/features/savings_goal/presentation/viewmodel/savings_goal_detail_cubit.dart';
import 'package:spendly_app/features/savings_goal/presentation/viewmodel/savings_goal_form_cubit.dart';
import 'package:spendly_app/features/settings/presentation/view/settings_page.dart';
import 'package:spendly_app/features/splash/presentation/view/splash_page.dart';
import 'package:spendly_app/features/transaction_history/presentation/view/history_page.dart';
import 'package:spendly_app/features/transaction_history/presentation/viewmodel/history_cubit.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/core/di/injection.dart';

/// Every route fades in/out (no slide-push) per design — screens feel like
/// they show/hide rather than get pushed over one another.
CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// Typed route table — each page that needs its own ViewModel wraps itself
/// in a `BlocProvider` here so navigation always creates a fresh Cubit
/// (Dashboard/Calendar/Reports/...) while AuthCubit/ThemeCubit (app-wide) are
/// injected as the pre-existing singletons via MultiBlocProvider in main.dart.
abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fadePage(state, const SplashPage()),
      ),
      GoRoute(
        path: '/language-select',
        pageBuilder: (context, state) =>
            _fadePage(state, const LanguageSelectPage()),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _fadePage(state, const OnboardingPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fadePage(state, const LoginPage()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _fadePage(state, const RegisterPage()),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) =>
            _fadePage(state, const ForgotPasswordPage()),
      ),
      GoRoute(
        path: '/verify-otp',
        pageBuilder: (context, state) =>
            _fadePage(state, VerifyOtpPage(args: state.extra as VerifyOtpArgs)),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => DashboardCubit(getIt(), getIt(), getIt()),
            child: const DashboardPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/add-transaction',
        pageBuilder: (context, state) {
          final initialTab = state.uri.queryParameters['type'] == 'income'
              ? TransactionType.income
              : TransactionType.expense;
          final dateParam = state.uri.queryParameters['date'];
          return _fadePage(
            state,
            BlocProvider(
              create: (_) => AddTransactionCubit(
                getIt(),
                getIt(),
                getIt(),
                initialTab: initialTab,
                existingTransaction: state.extra as Transaction?,
                initialDate:
                    dateParam == null ? null : DateTime.parse(dateParam),
              ),
              child: const AddTransactionPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/calendar',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => CalendarCubit(getIt(), getIt(), getIt()),
            child: const CalendarPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/reports',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => ReportsCubit(getIt()),
            child: const ReportsPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/budget',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => BudgetCubit(getIt()),
            child: const BudgetPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/add-budget',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => AddBudgetCubit(getIt(), getIt()),
            child: const AddBudgetPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/edit-budget',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) =>
                EditBudgetCubit(getIt(), getIt(), state.extra as BudgetItem),
            child: const EditBudgetPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/savings-goal',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => SavingsGoalDetailCubit(getIt(), getIt()),
            child: SavingsGoalDetailPage(goal: state.extra as SavingsGoal),
          ),
        ),
      ),
      GoRoute(
        path: '/savings-goal/form',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => SavingsGoalFormCubit(
              getIt(),
              getIt(),
              getIt(),
              existing: state.extra as SavingsGoal?,
            ),
            child: const SavingsGoalFormPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/recurring-transactions',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => RecurringTransactionListCubit(getIt()),
            child: const RecurringTransactionListPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/recurring-transactions/form',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => RecurringTransactionFormCubit(
              getIt(),
              getIt(),
              getIt(),
              getIt(),
              existing: state.extra as RecurringTransaction?,
            ),
            child: const RecurringTransactionFormPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => NotificationCenterCubit(
                getIt(), getIt(), getIt(), getIt()),
            child: const NotificationCenterPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/income',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => IncomeCubit(getIt(), getIt()),
            child: const IncomePage(),
          ),
        ),
      ),
      GoRoute(
        path: '/history',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => HistoryCubit(getIt(), getIt(), getIt()),
            child: const HistoryPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => _fadePage(state, const ProfilePage()),
      ),
      GoRoute(
        path: '/categories',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => CategoryCubit(getIt()),
            child: const CategoryListPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/categories/edit',
        pageBuilder: (context, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => CategoryEditCubit(
              getIt(),
              getIt(),
              getIt(),
              getIt(),
              (state.extra as CategoryEditArgs?) ?? const CategoryEditArgs(),
            ),
            child: const CategoryEditPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        pageBuilder: (context, state) =>
            _fadePage(state, const EditProfilePage()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _fadePage(state, const SettingsPage()),
      ),
      GoRoute(
        path: '/feedback-kit',
        pageBuilder: (context, state) =>
            _fadePage(state, const FeedbackKitPage()),
      ),
    ],
  );
}
