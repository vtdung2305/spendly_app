import 'package:get_it/get_it.dart';

import '../theme/theme_cubit.dart';
import '../../features/authentication/data/datasources/auth_mock_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository.dart';
import '../../features/authentication/domain/repositories/i_auth_repository.dart';
import '../../features/authentication/domain/usecases/get_current_user_usecase.dart';
import '../../features/authentication/domain/usecases/register_with_email_usecase.dart';
import '../../features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import '../../features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import '../../features/authentication/domain/usecases/sign_out_usecase.dart';
import '../../features/authentication/presentation/viewmodel/auth_cubit.dart';
import '../../features/transactions/data/datasources/transaction_mock_datasource.dart';
import '../../features/transactions/data/repositories/transaction_repository.dart';
import '../../features/transactions/domain/repositories/i_transaction_repository.dart';
import '../../features/transactions/domain/usecases/add_transaction_usecase.dart';
import '../../features/transactions/domain/usecases/get_calendar_summary_usecase.dart';
import '../../features/transactions/domain/usecases/get_dashboard_summary_usecase.dart';
import '../../features/transactions/domain/usecases/get_report_summary_usecase.dart';
import '../../features/transactions/domain/usecases/get_transactions_usecase.dart';
import '../../features/budget/data/datasources/budget_mock_datasource.dart';
import '../../features/budget/data/repositories/budget_repository.dart';
import '../../features/budget/domain/repositories/i_budget_repository.dart';
import '../../features/budget/domain/usecases/get_budgets_usecase.dart';

final getIt = GetIt.instance;

/// Registers every dependency once at app start. Pages resolve their own
/// Cubit via `getIt<Xxx>()` inside a `BlocProvider(create: ...)` — never
/// scattered `GetIt.instance<T>()` calls deep in the widget tree.
void configureDependencies() {
  // Data sources (swap for Supabase-backed ones without touching callers).
  getIt.registerLazySingleton(AuthMockDataSource.new);
  getIt.registerLazySingleton(TransactionMockDataSource.new);

  // Repositories
  getIt.registerLazySingleton<IAuthRepository>(() => AuthRepository(getIt()));
  getIt.registerLazySingleton<ITransactionRepository>(() => TransactionRepository(getIt()));

  // Use cases — Authentication
  getIt.registerFactory(() => GetCurrentUserUseCase(getIt()));
  getIt.registerFactory(() => SignInWithEmailUseCase(getIt()));
  getIt.registerFactory(() => SignInWithGoogleUseCase(getIt()));
  getIt.registerFactory(() => RegisterWithEmailUseCase(getIt()));
  getIt.registerFactory(() => SignOutUseCase(getIt()));

  // Use cases — Transactions
  getIt.registerFactory(() => GetDashboardSummaryUseCase(getIt()));
  getIt.registerFactory(() => AddTransactionUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsUseCase(getIt()));
  getIt.registerFactory(() => GetCalendarSummaryUseCase(getIt()));
  getIt.registerFactory(() => GetReportSummaryUseCase(getIt()));

  // Budget feature
  getIt.registerLazySingleton(BudgetMockDataSource.new);
  getIt.registerLazySingleton<IBudgetRepository>(() => BudgetRepository(getIt()));
  getIt.registerFactory(() => GetBudgetsUseCase(getIt()));

  // AuthCubit is app-wide (session), registered as a singleton so Splash,
  // Profile, and the router redirect all observe the same instance.
  getIt.registerLazySingleton(
    () => AuthCubit(
      getCurrentUserUseCase: getIt(),
      signInWithEmailUseCase: getIt(),
      signInWithGoogleUseCase: getIt(),
      registerWithEmailUseCase: getIt(),
      signOutUseCase: getIt(),
    ),
  );

  // ThemeCubit is app-wide — Profile's Dark mode toggle flips it instantly
  // and Settings reads the same instance.
  getIt.registerLazySingleton(ThemeCubit.new);
}
