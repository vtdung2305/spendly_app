import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/authentication/domain/entities/app_user.dart';
import 'package:spendly_app/features/authentication/domain/entities/register_outcome.dart';

/// Auth session boundary. Data layer implements this against Supabase Auth
/// (or a mock, until the backend is wired up).
abstract class IAuthRepository {
  /// Returns the current session's user, or null if signed out.
  Future<Either<Failure, AppUser?>> getCurrentUser();

  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signInWithGoogle();

  Future<Either<Failure, AppUser>> signInWithFacebook();

  Future<Either<Failure, RegisterOutcome>> registerWithEmail({
    required String email,
    required String password,
  });

  /// Completes registration once the user enters the emailed 6-digit code —
  /// only meaningful on the custom backend path (Supabase uses its own
  /// link-based email confirmation instead).
  Future<Either<Failure, AppUser>> verifyOtp({
    required String email,
    required String code,
  });

  /// Requests a fresh OTP code (invalidates the previous one).
  Future<Either<Failure, Unit>> resendOtp(String email);

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  /// Updates the signed-in user's profile fields (screen 12b — Edit
  /// Profile). [address] may be empty (it's the only optional field).
  Future<Either<Failure, AppUser>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  });
}
