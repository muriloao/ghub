import '../cache/cache_manager.dart';
import '../cache/models/game_cache_model.dart';

/// Serviço especializado para cache de jogos com performance otimizada
class OptimizedGamesCacheService {
  /// Cache jogos do Steam com conversão otimizada
  static Future<void> cacheSteamGames(
    List<Map<String, dynamic>> steamGames,
  ) async {
    final gameModels = steamGames
        .map((game) => GameCacheModel.fromSteamGame(game))
        .toList();

    await CacheManager.cacheGames(gameModels);
  }

  /// Recupera jogos do Steam do cache
  static List<GameCacheModel> getCachedSteamGames() {
    return CacheManager.getGamesByPlatform('steam');
  }

  /// Busca otimizada com filtros
  static List<GameCacheModel> searchGames({
    String? platform,
    String? query,
    bool? favoritesOnly,
    int? minPlaytime,
  }) {
    var games = platform != null
        ? CacheManager.getGamesByPlatform(platform)
        : CacheManager.getAllGames();

    if (query != null && query.isNotEmpty) {
      games = games
          .where(
            (game) => game.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    if (favoritesOnly == true) {
      games = games.where((game) => game.isFavorite).toList();
    }

    if (minPlaytime != null) {
      games = games
          .where((game) => game.playtimeMinutes >= minPlaytime)
          .toList();
    }

    return games;
  }

  /// Estatísticas de jogos para dashboard
  static GameStats getGameStats() {
    final allGames = CacheManager.getAllGames();

    return GameStats(
      totalGames: allGames.length,
      favoriteGames: allGames.where((g) => g.isFavorite).length,
      totalPlaytime: allGames.fold(
        0,
        (sum, game) => sum + game.playtimeMinutes,
      ),
      steamGames: allGames.where((g) => g.platform == 'steam').length,
      recentlyPlayed: allGames
          .where(
            (g) =>
                g.lastPlayed != null &&
                DateTime.now().difference(g.lastPlayed!).inDays <= 7,
          )
          .length,
    );
  }

  /// Migra dados antigos do SharedPreferences para Hive (uma única vez)
  static Future<void> migrateLegacyCache() async {
    // Esta função será chamada uma única vez para migrar dados antigos
    // Implementar lógica de migração se necessário
  }

  /// Força sincronização se necessário
  static Future<bool> shouldSync() async {
    return await CacheManager.needsGameSync();
  }

  /// Marca/desmarca jogo como favorito
  static Future<void> toggleGameFavorite(String gameId) async {
    await CacheManager.toggleGameFavorite(gameId);
  }
}

/// Classe para estatísticas de jogos
class GameStats {
  final int totalGames;
  final int favoriteGames;
  final int totalPlaytime;
  final int steamGames;
  final int recentlyPlayed;

  GameStats({
    required this.totalGames,
    required this.favoriteGames,
    required this.totalPlaytime,
    required this.steamGames,
    required this.recentlyPlayed,
  });

  double get averagePlaytimeHours =>
      totalGames > 0 ? (totalPlaytime / 60.0) / totalGames : 0.0;

  String get totalPlaytimeFormatted {
    final hours = totalPlaytime ~/ 60;
    final minutes = totalPlaytime % 60;
    return '${hours}h ${minutes}m';
  }
}
