class EpicGamesConfig {
  // Epic Games OAuth2 credentials - obtenha em: https://dev.epicgames.com/portal/
  // IMPORTANTE: Substitua pelas suas credenciais reais
  static const String clientId = 'SEU_EPIC_CLIENT_ID_AQUI';
  static const String clientSecret = 'SEU_EPIC_CLIENT_SECRET_AQUI';
  static const String redirectUri = 'ghubmobile://auth/epic-callback';

  // Epic Games API URLs
  static const String epicApiUrl = 'https://api.epicgames.dev';
  static const String authUrl = 'https://www.epicgames.com/id/authorize';
  static const String tokenUrl =
      'https://api.epicgames.dev/epic/oauth/v1/token';
  static const String userInfoUrl =
      'https://api.epicgames.dev/epic/id/v1/accounts';

  // Epic Games Store API
  static const String catalogUrl =
      'https://api.epicgames.dev/epic/ecom/v1/platforms/epic/catalogItems';
  static const String entitlementsUrl =
      'https://api.epicgames.dev/epic/ecom/v1/platforms/epic/identities';

  // OAuth2 scopes
  static const List<String> scopes = [
    'basic_profile',
    'ecom:read',
    'friends:read',
  ];

  // Rate limiting
  static const int maxRequestsPerMinute = 100;
  static const int rateLimitDelayMs = 200;

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
