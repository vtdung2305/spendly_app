/// Shared result shape for `AuthCubit.registerWithEmail`/`signInWithEmail`/
/// `verifyOtp` — exactly one of [otpEmail]/[errorMessage] is set, or neither
/// ([success]).
class AuthFormResult {
  const AuthFormResult({this.otpEmail, this.errorMessage, this.errorCode});

  /// Set when OTP verification is required before a session exists (either
  /// a fresh register, or a login against an unverified account). Unused by
  /// `verifyOtp` itself.
  final String? otpEmail;

  final String? errorMessage;

  /// The backend's `error.code` (e.g. `OTP_TOO_MANY_ATTEMPTS`), when
  /// available — lets Verify OTP show distinct copy per failure reason.
  final String? errorCode;

  bool get success => otpEmail == null && errorMessage == null;
}
