import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/register_with_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/update_profile_usecase.dart';
import 'package:spendly_app/features/authentication/domain/usecases/update_savings_goal_usecase.dart';
import 'auth_state.dart';

/// Owns the app-wide session: who's logged in, used by Splash to route and
/// by Profile to sign out. Login/Register forms report results back here so
/// the rest of the app (router redirect, Profile) reacts to one source of
/// truth instead of each page tracking its own "am I logged in" copy.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required RegisterWithEmailUseCase registerWithEmailUseCase,
    required SignOutUseCase signOutUseCase,
    required SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UpdateSavingsGoalUseCase updateSavingsGoalUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _signInWithEmailUseCase = signInWithEmailUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _registerWithEmailUseCase = registerWithEmailUseCase,
        _signOutUseCase = signOutUseCase,
        _sendPasswordResetEmailUseCase = sendPasswordResetEmailUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _updateSavingsGoalUseCase = updateSavingsGoalUseCase,
        super(const AuthInitial());

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final RegisterWithEmailUseCase _registerWithEmailUseCase;
  final SignOutUseCase _signOutUseCase;
  final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateSavingsGoalUseCase _updateSavingsGoalUseCase;

  Future<void> checkSession() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      emit(const AuthOffline());
      return;
    }
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) => emit(AuthCheckFailed(failure.message)),
      (user) => emit(
          user == null ? const AuthUnauthenticated() : AuthAuthenticated(user)),
    );
  }

  /// Returns an error message on failure, or null on success — the calling
  /// form (Login/Register page) owns its own submitting/spinner state.
  Future<String?> signInWithEmail(String email, String password) async {
    final result =
        await _signInWithEmailUseCase(email: email, password: password);
    return result.fold(
      (failure) => failure.message,
      (user) {
        emit(AuthAuthenticated(user));
        return null;
      },
    );
  }

  Future<String?> signInWithGoogle() async {
    final result = await _signInWithGoogleUseCase();
    return result.fold(
      (failure) => failure.message,
      (user) {
        emit(AuthAuthenticated(user));
        return null;
      },
    );
  }

  Future<String?> registerWithEmail(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final result = await _registerWithEmailUseCase(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    return result.fold(
      (failure) => failure.message,
      (user) {
        emit(AuthAuthenticated(user));
        return null;
      },
    );
  }

  Future<void> signOut() async {
    await _signOutUseCase();
    emit(const AuthUnauthenticated());
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    final result = await _sendPasswordResetEmailUseCase(email);
    return result.fold((failure) => failure.message, (_) => null);
  }

  Future<String?> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  }) async {
    final result = await _updateProfileUseCase(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      address: address,
    );
    return result.fold(
      (failure) => failure.message,
      (user) {
        emit(AuthAuthenticated(user));
        return null;
      },
    );
  }

  Future<String?> updateSavingsGoal(double amount) async {
    final result = await _updateSavingsGoalUseCase(amount);
    return result.fold(
      (failure) => failure.message,
      (user) {
        emit(AuthAuthenticated(user));
        return null;
      },
    );
  }
}
