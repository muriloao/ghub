class AppConstants {
  static const String appName = 'GHub';
  static const String appSlogan = 'Sync your stats. Dominate the game.';

  // API
  static const String baseUrl = 'https://api.gamecentral.com';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // Routes
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signup';
  static const String onboardingRoute = '/onboarding';
  static const String onboardingLoadingRoute = '/onboarding/loading';
  static const String homeRoute = '/home';
  static const String splashRoute = '/';
  static const String steamCallbackRoute = '/onboarding/callback';
  static const String xboxCallbackRoute = '/integrations/xbox-callback';
  static const String gameDetailRoute = '/game-detail';
  static const String integrationsRoute = '/integrations';
  static const String profileRoute = '/profile';
}
