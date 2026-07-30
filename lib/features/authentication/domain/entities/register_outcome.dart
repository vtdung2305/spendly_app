import 'package:spendly_app/features/authentication/domain/entities/app_user.dart';

/// Result of a register attempt. Exactly one of [user]/[otpEmail] is set:
/// [user] when registration authenticated immediately (Supabase mode with
/// email confirmation disabled); [otpEmail] when OTP verification is
/// required before a session exists (the custom backend, always).
class RegisterOutcome {
  const RegisterOutcome({this.user, this.otpEmail});

  final AppUser? user;
  final String? otpEmail;
}
