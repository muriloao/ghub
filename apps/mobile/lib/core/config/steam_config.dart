import 'package:flutter_dotenv/flutter_dotenv.dart';

class SteamConfig {
  // Steam Web API key - obtenha em: https://steamcommunity.com/dev/apikey
  // IMPORTANTE: Configure STEAM_API_KEY no arquivo .env
  static String? get apiKey => dotenv.env['STEAM_API_KEY'];

  // URLs da Steam API
  static String get steamApiUrl =>
      dotenv.env['STEAM_API_URL'] ?? 'https://api.steampowered.com';
  static String get steamOpenIdUrl =>
      dotenv.env['STEAM_OPENID_URL'] ?? 'https://steamcommunity.com/openid';
  static String get steamStoreApiUrl =>
      dotenv.env['STEAM_STORE_API_URL'] ?? 'https://store.steampowered.com/api';

  // Parâmetros de configuração para OpenID
  static String get realm =>
      dotenv.env['STEAM_REALM'] ?? 'https://localhost:3000';
  static String get mode => dotenv.env['STEAM_MODE'] ?? 'checkid_setup';
  static String get ns =>
      dotenv.env['STEAM_NS'] ?? 'http://specs.openid.net/auth/2.0';
  static String get identity =>
      dotenv.env['STEAM_IDENTITY'] ??
      'http://specs.openid.net/auth/2.0/identifier_select';
  static String get claimedId =>
      dotenv.env['STEAM_CLAIMED_ID'] ??
      'http://specs.openid.net/auth/2.0/identifier_select';

  // URL de retorno personalizada para o app móvel
  // Usa um scheme customizado que será capturado pelo app
  static String get returnUrl =>
      '${dotenv.env['APP_WEB_URL'] ?? ''}/integrations/steam-callback';

  // URLs específicas da Steam Web API para jogos
  static String get getOwnedGamesUrl =>
      '$steamApiUrl/IPlayerService/GetOwnedGames/v0001/';
  static String get getRecentlyPlayedGamesUrl =>
      '$steamApiUrl/IPlayerService/GetRecentlyPlayedGames/v0001/';
  static String get getPlayerSummariesUrl =>
      '$steamApiUrl/ISteamUser/GetPlayerSummaries/v0002/';
  static String get getPlayerAchievementsUrl =>
      '$steamApiUrl/ISteamUserStats/GetPlayerAchievements/v0001/';
  static String get getSchemaForGameUrl =>
      '$steamApiUrl/ISteamUserStats/GetSchemaForGame/v2/';
  static String get getGameDetailsUrl => '$steamStoreApiUrl/appdetails';

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
  static int get maxBatchSize =>
      int.tryParse(dotenv.env['STEAM_MAX_BATCH_SIZE'] ?? '100') ??
      100; // Máximo de jogos por requisição de detalhes
  static int get rateLimitDelayMs =>
      int.tryParse(dotenv.env['STEAM_RATE_LIMIT_DELAY_MS'] ?? '100') ??
      100; // Delay entre requests em batch
}
