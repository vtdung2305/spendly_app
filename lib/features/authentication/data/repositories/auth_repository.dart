import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/authentication/domain/entities/app_user.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';
import 'package:spendly_app/features/authentication/data/datasources/auth_remote_datasource.dart';

class AuthRepository implements IAuthRepository {
  const AuthRepository(this._dataSource);
  final AuthRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      final model = await _dataSource.getCurrentUser();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _dataSource.signInWithEmail(email, password);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    try {
      final model = await _dataSource.signInWithGoogle();
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _dataSource.registerWithEmail(email, password);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  }) async {
    try {
      final model = await _dataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        address: address,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> updateSavingsGoal(double amount) async {
    try {
      final model = await _dataSource.updateSavingsGoal(amount);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
