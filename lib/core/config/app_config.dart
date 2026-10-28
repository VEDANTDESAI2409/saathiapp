class AppConfig {
  static const String appName = 'SaathiApp';
  static const String appVersion = '1.0.0';

  // Configurable Helpline Number (Empty string by default until genuine number is provided)
  static String helplineNumber = '';
  static const String helplineHours = '9:00 AM - 9:00 PM IST (Mon-Sat)';

  // Monthly help instance limit policy (10 - 15)
  static const int monthlyHelpLimit = 15;

  // Backend Integration URL (Configurable)
  static String apiBaseUrl = 'https://api.saathiapp.org/v1';

  // Verification & Policy Flags
  static bool requireIdentityVerificationForEmergency = false;
  static bool enableEmergencyBroadcasting = true;

  // Helper check if genuine helpline number is configured
  static bool isHelplineConfigured() {
    return helplineNumber.trim().isNotEmpty && helplineNumber != '0000000000';
  }
}
