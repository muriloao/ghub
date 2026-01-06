class SteamConfig {
  // Steam Web API key - obtenha em: https://steamcommunity.com/dev/apikey
  // IMPORTANTE: Configure STEAM_API_KEY no arquivo .env
  static const String apiKey = String.fromEnvironment(
    'STEAM_API_KEY',
    defaultValue: 'SEU_STEAM_API_KEY_AQUI',
  );

  // URLs da Steam API
  static const String steamApiUrl = String.fromEnvironment(
    'STEAM_API_URL',
    defaultValue: 'https://api.steampowered.com',
  );
  static const String steamOpenIdUrl = String.fromEnvironment(
    'STEAM_OPENID_URL',
    defaultValue: 'https://steamcommunity.com/openid',
  );
  static const String steamStoreApiUrl = String.fromEnvironment(
    'STEAM_STORE_API_URL',
    defaultValue: 'https://store.steampowered.com/api',
  );

  // Parâmetros de configuração para OpenID
  static const String realm = String.fromEnvironment(
    'STEAM_REALM',
    defaultValue: 'https://localhost:3000',
  );
  static const String mode = String.fromEnvironment(
    'STEAM_MODE',
    defaultValue: 'checkid_setup',
  );
  static const String ns = String.fromEnvironment(
    'STEAM_NS',
    defaultValue: 'http://specs.openid.net/auth/2.0',
  );
  static const String identity = String.fromEnvironment(
    'STEAM_IDENTITY',
    defaultValue: 'http://specs.openid.net/auth/2.0/identifier_select',
  );
  static const String claimedId = String.fromEnvironment(
    'STEAM_CLAIMED_ID',
    defaultValue: 'http://specs.openid.net/auth/2.0/identifier_select',
  );

  // URL de retorno personalizada para o app móvel
  // Usa um scheme customizado que será capturado pelo app
  static const String returnUrl =
      '${SteamConfig.realm}/auth/steam/callback'; // 'ghub://auth/steam/callback';

  // URLs específicas da Steam Web API para jogos
  static const String getOwnedGamesUrl =
      '$steamApiUrl/IPlayerService/GetOwnedGames/v0001/';
  static const String getRecentlyPlayedGamesUrl =
      '$steamApiUrl/IPlayerService/GetRecentlyPlayedGames/v0001/';
  static const String getPlayerSummariesUrl =
      '$steamApiUrl/ISteamUser/GetPlayerSummaries/v0002/';
  static const String getPlayerAchievementsUrl =
      '$steamApiUrl/ISteamUserStats/GetPlayerAchievements/v0001/';
  static const String getSchemaForGameUrl =
      '$steamApiUrl/ISteamUserStats/GetSchemaForGame/v2/';
  static const String getGameDetailsUrl = '$steamStoreApiUrl/appdetails';

  // URLs para imagens de jogos Steam
  static String getGameHeaderImageUrl(String appId) =>
      'https://cdn.akamai.steamstatic.com/steam/apps/$appId/header.jpg';

  static String getGameCapsuleImageUrl(String appId) =>
      'https://cdn.akamai.steamstatic.com/steam/apps/$appId/capsule_231x87.jpg';

  static String getGameLibraryHeroUrl(String appId) =>
      'https://cdn.akamai.steamstatic.com/steam/apps/$appId/library_hero.jpg';

  static String getGameIconUrl(String appId, String iconHash) =>
      'https://media.steampowered.com/steamcommunity/public/images/apps/$appId/$iconHash.jpg';

  // Configurações de rate limiting
  static const int maxBatchSize = int.fromEnvironment(
    'STEAM_MAX_BATCH_SIZE',
    defaultValue: 100,
  ); // Máximo de jogos por requisição de detalhes
  static const int rateLimitDelayMs = int.fromEnvironment(
    'STEAM_RATE_LIMIT_DELAY_MS',
    defaultValue: 100,
  ); // Delay entre requests em batch
}
