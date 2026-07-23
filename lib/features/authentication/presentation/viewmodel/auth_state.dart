import 'package:equatable/equatable.dart';

import '../../domain/entities/app_user.dart';

/// Global auth/session state — read by Splash (routing decision) and Profile
/// (sign out). Distinct from [AuthFormStatus] which tracks a single form's
/// submit lifecycle.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final AppUser user;

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthCheckFailed extends AuthState {
  const AuthCheckFailed(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
