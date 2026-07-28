import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spendly_app/core/locale/locale_cubit.dart';
import 'package:spendly_app/core/storage/local_storage.dart';
import 'package:spendly_app/core/theme/theme_cubit.dart';
import 'package:spendly_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:spendly_app/features/authentication/data/repositories/auth_repository.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';
import 'package:spendly_app/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/register_with_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/update_profile_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/update_savings_goal_usecase.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';
import 'package:spendly_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:spendly_app/features/transactions/data/repositories/transaction_repository.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:spendly_app/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_calendar_summary_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_report_summary_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_transactions_for_day_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_year_to_date_savings_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:spendly_app/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:spendly_app/features/budget/data/repositories/budget_repository.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';
import 'package:spendly_app/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:spendly_app/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:spendly_app/features/budget/domain/usecases/get_budgets_usecase.dart';

final getIt = GetIt.instance;

/// Registers every dependency once at app start. Pages resolve their own
/// Cubit via `getIt<Xxx>()` inside a `BlocProvider(create: ...)` — never
/// scattered `GetIt.instance<T>()` calls deep in the widget tree.
///
/// Call after `Supabase.initialize(...)` — every datasource here reads
/// `Supabase.instance.client`.
Future<void> configureDependencies() async {
  final supabaseClient = Supabase.instance.client;
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => AppLocalStorage(sharedPreferences));

  // Data sources
  getIt.registerLazySingleton(() => AuthRemoteDataSource(supabaseClient));
  getIt
      .registerLazySingleton(() => TransactionRemoteDataSource(supabaseClient));
  getIt.registerLazySingleton(() => BudgetRemoteDataSource(supabaseClient));

  // Repositories
  getIt.registerLazySingleton<IAuthRepository>(() => AuthRepository(getIt()));
  getIt.registerLazySingleton<ITransactionRepository>(
    () => TransactionRepository(getIt(), getIt()),
  );
  getIt.registerLazySingleton<IBudgetRepository>(
      () => BudgetRepository(getIt(), getIt()));

  // Use cases — Authentication
  getIt.registerFactory(() => GetCurrentUserUseCase(getIt()));
  getIt.registerFactory(() => SignInWithEmailUseCase(getIt()));
  getIt.registerFactory(() => SignInWithGoogleUseCase(getIt()));
  getIt.registerFactory(() => RegisterWithEmailUseCase(getIt()));
  getIt.registerFactory(() => SignOutUseCase(getIt()));
  getIt.registerFactory(() => SendPasswordResetEmailUseCase(getIt()));
  getIt.registerFactory(() => UpdateProfileUseCase(getIt()));
  getIt.registerFactory(() => UpdateSavingsGoalUseCase(getIt()));

  // Use cases — Transactions
  getIt.registerFactory(() => GetDashboardSummaryUseCase(getIt()));
  getIt.registerFactory(() => AddTransactionUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsUseCase(getIt()));
  getIt.registerFactory(() => GetCalendarSummaryUseCase(getIt()));
  getIt.registerFactory(() => GetReportSummaryUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsForDayUseCase(getIt()));
  getIt.registerFactory(() => UpdateTransactionUseCase(getIt()));
  getIt.registerFactory(() => DeleteTransactionUseCase(getIt()));
  getIt.registerFactory(() => GetYearToDateSavingsUseCase(getIt()));

  // Use cases — Budget
  getIt.registerFactory(() => GetBudgetsUseCase(getIt()));
  getIt.registerFactory(() => AddBudgetUseCase(getIt()));
  getIt.registerFactory(() => DeleteBudgetUseCase(getIt()));

  // AuthCubit is app-wide (session), registered as a singleton so Splash,
  // Profile, and the router redirect all observe the same instance.
  getIt.registerLazySingleton(
    () => AuthCubit(
      getCurrentUserUseCase: getIt(),
      signInWithEmailUseCase: getIt(),
      signInWithGoogleUseCase: getIt(),
      registerWithEmailUseCase: getIt(),
      signOutUseCase: getIt(),
      sendPasswordResetEmailUseCase: getIt(),
      updateProfileUseCase: getIt(),
      updateSavingsGoalUseCase: getIt(),
    ),
  );

  // ThemeCubit is app-wide — Profile's Dark mode toggle flips it instantly
  // and Settings reads the same instance.
  getIt.registerLazySingleton(ThemeCubit.new);

  // LocaleCubit is app-wide — null state (no language chosen yet) gates
  // Splash into the first-launch Language Select screen.
  getIt.registerLazySingleton(() => LocaleCubit(getIt()));
}
