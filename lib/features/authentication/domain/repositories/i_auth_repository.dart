import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_user.dart';

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

  Future<Either<Failure, AppUser>> registerWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();
}
