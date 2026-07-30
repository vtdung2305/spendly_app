import 'package:equatable/equatable.dart';

/// Base failure type returned by repositories via `Either<Failure, T>`.
abstract class Failure extends Equatable {
  const Failure(this.message, {this.code});

  final String message;

  /// The backend's machine-readable `error.code` (e.g. `EMAIL_NOT_VERIFIED`),
  /// when this failure came from a `BackendApiException` — lets callers
  /// branch on a stable code instead of matching the human-readable
  /// [message]. Null for Supabase-mode failures and generic/network errors.
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}
