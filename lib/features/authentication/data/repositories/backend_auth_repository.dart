import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/core/network/backend_error_mapper.dart';
import 'package:spendly_app/features/authentication/data/datasources/backend_auth_remote_datasource.dart'
    show BackendAuthRemoteDataSource, OAuthCancelledException;
import 'package:spendly_app/features/authentication/domain/entities/app_user.dart';
import 'package:spendly_app/features/authentication/domain/entities/register_outcome.dart';
import 'package:spendly_app/features/authentication/domain/repositories/i_auth_repository.dart';

class BackendAuthRepository implements IAuthRepository {
  const BackendAuthRepository(this._dataSource);
  final BackendAuthRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      final model = await _dataSource.getCurrentUser();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(mapBackendError(e));
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
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    try {
      final model = await _dataSource.signInWithGoogle();
      return Right(model.toEntity());
    } on OAuthCancelledException catch (_) {
      return const Left(AuthFailure('', code: 'OAUTH_CANCELLED'));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithFacebook() async {
    try {
      final model = await _dataSource.signInWithFacebook();
      return Right(model.toEntity());
    } on OAuthCancelledException catch (_) {
      return const Left(AuthFailure('', code: 'OAUTH_CANCELLED'));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, RegisterOutcome>> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final otpEmail = await _dataSource.registerWithEmail(email, password);
      return Right(RegisterOutcome(otpEmail: otpEmail));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final model = await _dataSource.verifyOtp(email, code);
      return Right(model.toEntity());
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendOtp(String email) async {
    try {
      await _dataSource.resendOtp(email);
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
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
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }
}
