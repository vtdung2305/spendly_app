/// Navigation args for `/verify-otp`. [autoResend] is set when arriving via
/// Login's `403 EMAIL_NOT_VERIFIED` path — the original code from register
/// is likely expired by the time the user retries login, so a fresh one is
/// sent proactively before the user does anything.
class VerifyOtpArgs {
  const VerifyOtpArgs({required this.email, this.autoResend = false});

  final String email;
  final bool autoResend;
}
