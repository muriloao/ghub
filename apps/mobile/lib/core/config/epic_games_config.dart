import 'package:flutter_dotenv/flutter_dotenv.dart';

class EpicGamesConfig {
  // Epic Games OAuth2 credentials - obtenha em: https://dev.epicgames.com/portal/
  // IMPORTANTE: Configure no arquivo .env
  static String get clientId =>
      dotenv.env['EPIC_CLIENT_ID'] ?? 'SEU_EPIC_CLIENT_ID_AQUI';
  static String get clientSecret =>
      dotenv.env['EPIC_CLIENT_SECRET'] ?? 'SEU_EPIC_CLIENT_SECRET_AQUI';
  static String get redirectUri =>
      '${dotenv.env['APP_WEB_URL'] ?? ''}/integrations/epic-callback';

  // Epic Games API URLs
  static String get epicApiUrl =>
      dotenv.env['EPIC_API_URL'] ?? 'https://api.epicgames.dev';
  static String get authUrl =>
      dotenv.env['EPIC_AUTH_URL'] ?? 'https://www.epicgames.com/id/authorize';
  static String get tokenUrl =>
      dotenv.env['EPIC_TOKEN_URL'] ??
      'https://api.epicgames.dev/epic/oauth/v1/token';
  static String get userInfoUrl =>
      dotenv.env['EPIC_USER_INFO_URL'] ??
      'https://api.epicgames.dev/epic/id/v1/accounts';

  // Epic Games Store API
  static String get catalogUrl =>
      dotenv.env['EPIC_CATALOG_URL'] ??
      'https://api.epicgames.dev/epic/ecom/v1/platforms/epic/catalogItems';
  static String get entitlementsUrl =>
      dotenv.env['EPIC_ENTITLEMENTS_URL'] ??
      'https://api.epicgames.dev/epic/ecom/v1/platforms/epic/identities';

  // OAuth2 scopes
  static List<String> get scopes {
    final scopesString =
        dotenv.env['EPIC_SCOPES'] ?? 'basic_profile ecom:read friends:read';
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
