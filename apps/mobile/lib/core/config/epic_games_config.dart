class EpicGamesConfig {
  // Epic Games OAuth2 credentials - obtenha em: https://dev.epicgames.com/portal/
  // IMPORTANTE: Configure no arquivo .env
  static const String clientId = String.fromEnvironment(
    'EPIC_CLIENT_ID',
    defaultValue: 'SEU_EPIC_CLIENT_ID_AQUI',
  );
  static const String clientSecret = String.fromEnvironment(
    'EPIC_CLIENT_SECRET',
    defaultValue: 'SEU_EPIC_CLIENT_SECRET_AQUI',
  );
  static const String redirectUri = String.fromEnvironment(
    'EPIC_REDIRECT_URI',
    defaultValue: 'ghubmobile://auth/epic-callback',
  );

  // Epic Games API URLs
  static const String epicApiUrl = String.fromEnvironment(
    'EPIC_API_URL',
    defaultValue: 'https://api.epicgames.dev',
  );
  static const String authUrl = String.fromEnvironment(
    'EPIC_AUTH_URL',
    defaultValue: 'https://www.epicgames.com/id/authorize',
  );
  static const String tokenUrl = String.fromEnvironment(
    'EPIC_TOKEN_URL',
    defaultValue: 'https://api.epicgames.dev/epic/oauth/v1/token',
  );
  static const String userInfoUrl = String.fromEnvironment(
    'EPIC_USER_INFO_URL',
    defaultValue: 'https://api.epicgames.dev/epic/id/v1/accounts',
  );

  // Epic Games Store API
  static const String catalogUrl = String.fromEnvironment(
    'EPIC_CATALOG_URL',
    defaultValue:
        'https://api.epicgames.dev/epic/ecom/v1/platforms/epic/catalogItems',
  );
  static const String entitlementsUrl = String.fromEnvironment(
    'EPIC_ENTITLEMENTS_URL',
    defaultValue:
        'https://api.epicgames.dev/epic/ecom/v1/platforms/epic/identities',
  );

  // OAuth2 scopes
  static List<String> get scopes {
    const scopesString = String.fromEnvironment(
      'EPIC_SCOPES',
      defaultValue: 'basic_profile ecom:read friends:read',
    );
    return scopesString.split(' ');
  }

  // Rate limiting
  static const int maxRequestsPerMinute = int.fromEnvironment(
    'EPIC_MAX_REQUESTS_PER_MINUTE',
    defaultValue: 100,
  );
  static const int rateLimitDelayMs = int.fromEnvironment(
    'EPIC_RATE_LIMIT_DELAY_MS',
    defaultValue: 200,
  );

  // URLs para construção do auth URL
  static String buildAuthUrl({required String state}) {
    final scopeString = scopes.join(' ');
    final params = {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'scope': scopeString,
      'state': state,
    };

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return '$authUrl?$queryString';
  }
}
