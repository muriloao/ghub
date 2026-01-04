class SteamConfig {
  // Steam Web API key - obtenha em: https://steamcommunity.com/dev/apikey
  // IMPORTANTE: Substitua 'SEU_STEAM_API_KEY_AQUI' pela sua chave real antes de usar
  static const String apiKey = '2271A33223BD2AEE98383AB2E8C2941C';

  // URLs da Steam API
  static const String steamApiUrl = 'https://api.steampowered.com';
  static const String steamOpenIdUrl = 'https://steamcommunity.com/openid';
  static const String steamStoreApiUrl = 'https://store.steampowered.com/api';

  // Parâmetros de configuração para OpenID
  static const String realm = 'https://5d2a47d81b16.ngrok-free.app';
  static const String mode = 'checkid_setup';
  static const String ns = 'http://specs.openid.net/auth/2.0';
  static const String identity =
      'http://specs.openid.net/auth/2.0/identifier_select';
  static const String claimedId =
      'http://specs.openid.net/auth/2.0/identifier_select';

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
  static const int maxBatchSize =
      100; // Máximo de jogos por requisição de detalhes
  static const int rateLimitDelayMs = 100; // Delay entre requests em batch
}
