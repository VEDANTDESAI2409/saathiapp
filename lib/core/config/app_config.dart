class AppConfig {
  static const String appName = 'SaathiApp';
  static const String appVersion = '1.0.0';

  // Configurable Helpline (Default charity support number)
  static String helplineNumber = '+91 8000 722 844';
  static const String helplineHours = '9:00 AM - 9:00 PM IST (Mon-Sat)';

  // Monthly help instance limit policy (10 - 15)
  static const int monthlyHelpLimit = 15;

  // Backend Integration URL (Configurable)
  static String apiBaseUrl = 'https://api.saathiapp.org/v1';

  // Verification & Policy Flags
  static bool requireIdentityVerificationForEmergency = false;
  static bool enableEmergencyBroadcasting = true;

  // Helper check if helpline is configured
  static bool isHelplineConfigured() {
    return helplineNumber.trim().isNotEmpty && helplineNumber != '0000000000';
  }
}
