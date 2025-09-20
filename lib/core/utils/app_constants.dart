class AppConstants {
  // App/Play store IDs
  static const String androidID = '';
  static const String iosId = '';

  // BaseUrls
  static const String baseUrl = 'http://131.153.18.44:8080/api/v1/client/';

  // App/Play store urls
  static const String appStore =
      'https://play.google.com/store/apps/details?id=com.otashqassob&hl=en';
  static const String playStore =
      'https://play.google.com/store/apps/details?id=com.otashqassob&hl=en';

  static int confirmCodeSeconds = 120;

  // Support, Terms and privacy link
  static const String support =
      'https://play.google.com/store/apps/details?id=com.otashqassob&hl=en';
  static const String privacyPolice =
      'https://play.google.com/store/apps/details?id=com.otashqassob&hl=en';
  static const String termsOfServices =
      'https://play.google.com/store/apps/details?id=com.otashqassob&hl=en';

  const AppConstants._();
}

enum Status {
  initial,
  error,
  success,
  loading,
  errorNetwork,
  profileLoading,
  imageLoading,
  adLoading,
}
