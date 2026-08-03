import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spendly_app/core/config/env_config.dart';
import 'package:spendly_app/core/locale/locale_cubit.dart';
import 'package:spendly_app/core/network/backend_api_client.dart';
import 'package:spendly_app/core/network/token_storage.dart';
import 'package:spendly_app/core/storage/local_storage.dart';
import 'package:spendly_app/core/theme/theme_cubit.dart';
import 'package:spendly_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:spendly_app/features/authentication/data/datasources/backend_auth_remote_datasource.dart';
import 'package:spendly_app/features/authentication/data/repositories/auth_repository.dart';
import 'package:spendly_app/features/authentication/data/repositories/backend_auth_repository.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';
import 'package:spendly_app/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/register_with_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/resend_otp_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_facebook_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/update_profile_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';
import 'package:spendly_app/features/transactions/data/datasources/backend_transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/data/repositories/backend_transaction_repository.dart';
import 'package:spendly_app/features/transactions/data/repositories/transaction_repository.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:spendly_app/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_calendar_summary_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_report_summary_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_transactions_for_day_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:spendly_app/features/budget/data/datasources/backend_budget_remote_datasource.dart';
import 'package:spendly_app/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:spendly_app/features/budget/data/repositories/backend_budget_repository.dart';
import 'package:spendly_app/features/budget/data/repositories/budget_repository.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';
import 'package:spendly_app/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:spendly_app/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:spendly_app/features/budget/domain/usecases/get_budgets_usecase.dart';
import 'package:spendly_app/features/category_management/data/datasources/backend_category_remote_datasource.dart';
import 'package:spendly_app/features/category_management/data/datasources/category_remote_datasource.dart';
import 'package:spendly_app/features/category_management/data/repositories/backend_category_repository.dart';
import 'package:spendly_app/features/category_management/data/repositories/category_repository.dart';
import 'package:spendly_app/features/category_management/domain/repositories/i_category_repository.dart';
import 'package:spendly_app/features/category_management/domain/usecases/add_category_usecase.dart';
import 'package:spendly_app/features/category_management/domain/usecases/delete_category_usecase.dart';
import 'package:spendly_app/features/category_management/domain/usecases/get_categories_usecase.dart';
import 'package:spendly_app/features/category_management/domain/usecases/update_category_usecase.dart';
import 'package:spendly_app/features/notification/data/datasources/backend_notification_remote_datasource.dart';
import 'package:spendly_app/features/notification/data/repositories/backend_notification_repository.dart';
import 'package:spendly_app/features/notification/domain/repositories/i_notification_repository.dart';
import 'package:spendly_app/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:spendly_app/features/notification/domain/usecases/get_reminder_settings_usecase.dart';
import 'package:spendly_app/features/notification/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:spendly_app/features/notification/domain/usecases/update_reminder_settings_usecase.dart';
import 'package:spendly_app/features/recurring_transaction/data/datasources/backend_recurring_transaction_remote_datasource.dart';
import 'package:spendly_app/features/recurring_transaction/data/repositories/backend_recurring_transaction_repository.dart';
import 'package:spendly_app/features/recurring_transaction/domain/repositories/i_recurring_transaction_repository.dart';
import 'package:spendly_app/features/recurring_transaction/domain/usecases/add_recurring_transaction_usecase.dart';
import 'package:spendly_app/features/recurring_transaction/domain/usecases/delete_recurring_transaction_usecase.dart';
import 'package:spendly_app/features/recurring_transaction/domain/usecases/get_recurring_transactions_usecase.dart';
import 'package:spendly_app/features/recurring_transaction/domain/usecases/update_recurring_transaction_usecase.dart';
import 'package:spendly_app/features/savings_goal/data/datasources/backend_savings_goal_remote_datasource.dart';
import 'package:spendly_app/features/savings_goal/data/datasources/savings_goal_remote_datasource.dart';
import 'package:spendly_app/features/savings_goal/data/repositories/backend_savings_goal_repository.dart';
import 'package:spendly_app/features/savings_goal/data/repositories/savings_goal_repository.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/add_savings_goal_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/get_savings_contribution_history_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/get_savings_goal_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/update_savings_goal_usecase.dart';

final getIt = GetIt.instance;

/// Registers every dependency once at app start. Pages resolve their own
/// Cubit via `getIt<Xxx>()` inside a `BlocProvider(create: ...)` — never
/// scattered `GetIt.instance<T>()` calls deep in the widget tree.
///
/// In Supabase mode, call after `Supabase.initialize(...)` — the Supabase
/// datasources here read `Supabase.instance.client`. In backend mode,
/// Supabase is never initialized, so `Supabase.instance.client` must not be
/// touched at all.
Future<void> configureDependencies() async {
  final useBackend = EnvConfig.dataSource == DataSourceMode.backend;
  final supabaseClient = useBackend ? null : Supabase.instance.client;
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => AppLocalStorage(sharedPreferences));

  // Backend API client — registered unconditionally (lazy, no I/O until
  // first real use) so it's harmless for Supabase-only setups.
  getIt.registerLazySingleton(() => TokenStorage(const FlutterSecureStorage()));
  getIt.registerLazySingleton(() => BackendApiClient(getIt()));

  // Data sources
  if (useBackend) {
    getIt.registerLazySingleton(
        () => BackendAuthRemoteDataSource(getIt(), getIt()));
    getIt.registerLazySingleton(() => BackendCategoryRemoteDataSource(getIt()));
    getIt.registerLazySingleton(
        () => BackendTransactionRemoteDataSource(getIt()));
    getIt.registerLazySingleton(() => BackendBudgetRemoteDataSource(getIt()));
    getIt.registerLazySingleton(
        () => BackendSavingsGoalRemoteDataSource(getIt()));
    // Recurring Transactions has no Supabase-mode implementation — the
    // backend auto-generates transactions server-side (no equivalent cron
    // is possible from Flutter alone), so this is only registered here.
    getIt.registerLazySingleton(
        () => BackendRecurringTransactionRemoteDataSource(getIt()));
    // Notifications/Reminders similarly has no Supabase-mode
    // implementation — server-generated notifications + push delivery
    // have no equivalent without a backend of their own.
    getIt.registerLazySingleton(
        () => BackendNotificationRemoteDataSource(getIt()));
  } else {
    getIt.registerLazySingleton(() => AuthRemoteDataSource(supabaseClient!));
    getIt
        .registerLazySingleton(() => CategoryRemoteDataSource(supabaseClient!));
    getIt.registerLazySingleton(
        () => TransactionRemoteDataSource(supabaseClient!));
    getIt.registerLazySingleton(() => BudgetRemoteDataSource(supabaseClient!));
    getIt.registerLazySingleton(
        () => SavingsGoalRemoteDataSource(supabaseClient!));
  }

  // Repositories
  if (useBackend) {
    getIt.registerLazySingleton<IAuthRepository>(
        () => BackendAuthRepository(getIt()));
    getIt.registerLazySingleton<ICategoryRepository>(
        () => BackendCategoryRepository(getIt()));
    getIt.registerLazySingleton<ITransactionRepository>(
        () => BackendTransactionRepository(getIt(), getIt()));
    getIt.registerLazySingleton<IBudgetRepository>(
        () => BackendBudgetRepository(getIt()));
    getIt.registerLazySingleton<ISavingsGoalRepository>(
        () => BackendSavingsGoalRepository(getIt()));
    getIt.registerLazySingleton<IRecurringTransactionRepository>(
        () => BackendRecurringTransactionRepository(getIt()));
    getIt.registerLazySingleton<INotificationRepository>(
        () => BackendNotificationRepository(getIt()));
  } else {
    getIt.registerLazySingleton<IAuthRepository>(() => AuthRepository(getIt()));
    getIt.registerLazySingleton<ICategoryRepository>(
        () => CategoryRepository(getIt()));
    getIt.registerLazySingleton<ITransactionRepository>(
      () => TransactionRepository(getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<IBudgetRepository>(
        () => BudgetRepository(getIt(), getIt(), getIt()));
    getIt.registerLazySingleton<ISavingsGoalRepository>(
        () => SavingsGoalRepository(getIt(), getIt()));
  }

  // Use cases — Authentication
  getIt.registerFactory(() => GetCurrentUserUseCase(getIt()));
  getIt.registerFactory(() => SignInWithEmailUseCase(getIt()));
  getIt.registerFactory(() => SignInWithGoogleUseCase(getIt()));
  getIt.registerFactory(() => SignInWithFacebookUseCase(getIt()));
  getIt.registerFactory(() => RegisterWithEmailUseCase(getIt()));
  getIt.registerFactory(() => VerifyOtpUseCase(getIt()));
  getIt.registerFactory(() => ResendOtpUseCase(getIt()));
  getIt.registerFactory(() => SignOutUseCase(getIt()));
  getIt.registerFactory(() => SendPasswordResetEmailUseCase(getIt()));
  getIt.registerFactory(() => UpdateProfileUseCase(getIt()));

  // Use cases — Transactions
  getIt.registerFactory(() => GetDashboardSummaryUseCase(getIt()));
  getIt.registerFactory(() => AddTransactionUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsUseCase(getIt()));
  getIt.registerFactory(() => GetCalendarSummaryUseCase(getIt()));
  getIt.registerFactory(() => GetReportSummaryUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsForDayUseCase(getIt()));
  getIt.registerFactory(() => UpdateTransactionUseCase(getIt()));
  getIt.registerFactory(() => DeleteTransactionUseCase(getIt()));

  // Use cases — Budget
  getIt.registerFactory(() => GetBudgetsUseCase(getIt()));
  getIt.registerFactory(() => AddBudgetUseCase(getIt()));
  getIt.registerFactory(() => DeleteBudgetUseCase(getIt()));

  // Use cases — Category Management
  getIt.registerFactory(() => GetCategoriesUseCase(getIt()));
  getIt.registerFactory(() => AddCategoryUseCase(getIt()));
  getIt.registerFactory(() => UpdateCategoryUseCase(getIt()));
  getIt.registerFactory(() => DeleteCategoryUseCase(getIt()));

  // Use cases — Savings Goal
  getIt.registerFactory(() => GetSavingsGoalUseCase(getIt()));
  getIt.registerFactory(() => AddSavingsGoalUseCase(getIt()));
  getIt.registerFactory(() => UpdateSavingsGoalUseCase(getIt()));
  getIt.registerFactory(() => GetSavingsContributionHistoryUseCase(getIt()));

  // Use cases — Recurring Transactions (backend mode only, see the
  // repository registration above)
  if (useBackend) {
    getIt.registerFactory(() => GetRecurringTransactionsUseCase(getIt()));
    getIt.registerFactory(() => AddRecurringTransactionUseCase(getIt()));
    getIt.registerFactory(() => UpdateRecurringTransactionUseCase(getIt()));
    getIt.registerFactory(() => DeleteRecurringTransactionUseCase(getIt()));
  }

  // Use cases — Notifications/Reminders (backend mode only, see the
  // repository registration above)
  if (useBackend) {
    getIt.registerFactory(() => GetNotificationsUseCase(getIt()));
    getIt.registerFactory(() => MarkAllNotificationsReadUseCase(getIt()));
    getIt.registerFactory(() => GetReminderSettingsUseCase(getIt()));
    getIt.registerFactory(() => UpdateReminderSettingsUseCase(getIt()));
  }

  // AuthCubit is app-wide (session), registered as a singleton so Splash,
  // Profile, and the router redirect all observe the same instance.
  getIt.registerLazySingleton(
    () => AuthCubit(
      getCurrentUserUseCase: getIt(),
      signInWithEmailUseCase: getIt(),
      signInWithGoogleUseCase: getIt(),
      signInWithFacebookUseCase: getIt(),
      registerWithEmailUseCase: getIt(),
      verifyOtpUseCase: getIt(),
      resendOtpUseCase: getIt(),
      signOutUseCase: getIt(),
      sendPasswordResetEmailUseCase: getIt(),
      updateProfileUseCase: getIt(),
    ),
  );

  // ThemeCubit is app-wide — Profile's Dark mode toggle flips it instantly
  // and Settings reads the same instance.
  getIt.registerLazySingleton(ThemeCubit.new);

  // LocaleCubit is app-wide — null state (no language chosen yet) gates
  // Splash into the first-launch Language Select screen.
  getIt.registerLazySingleton(() => LocaleCubit(getIt()));
}
