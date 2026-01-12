import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/game_cache_model.dart';
import 'models/user_cache_model.dart';
import 'cache_adapters.dart';

/// Gerenciador central de cache otimizado para performance
class CacheManager {
  static CacheManager? _instance;
  static CacheManager get instance => _instance ??= CacheManager._();

  CacheManager._();

  // Boxes do Hive para dados estruturados
  static Box<GameCacheModel>? _gamesBox;
  static Box<UserCacheModel>? _usersBox;
  static Box<dynamic>? _metadataBox;

  // Storage tradicional para configurações e dados sensíveis
  static SharedPreferences? _prefs;
  static const _secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Inicializa todos os sistemas de cache
  static Future<void> initialize() async {
    try {
      debugPrint('🔧 Inicializando CacheManager...');

      // Inicializar Hive
      await Hive.initFlutter();

      // Registrar adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(GameCacheModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(UserCacheModelAdapter());
      }

      // Abrir boxes
      _gamesBox = await Hive.openBox<GameCacheModel>('games_cache');
      _usersBox = await Hive.openBox<UserCacheModel>('users_cache');
      _metadataBox = await Hive.openBox('metadata_cache');

      // Inicializar SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      debugPrint('✅ CacheManager inicializado com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar CacheManager: $e');
      rethrow;
    }
  }

  // ====== GAMES CACHE ======

  /// Salva jogos no cache com TTL automático
  static Future<void> cacheGames(List<GameCacheModel> games) async {
    if (_gamesBox == null) throw Exception('Cache não inicializado');

    debugPrint('💾 Cacheando ${games.length} jogos...');

    final Map<String, GameCacheModel> gamesMap = {};
    for (final game in games) {
      gamesMap[game.id] = game;
    }

    await _gamesBox!.putAll(gamesMap);
    await _updateCacheMetadata('games_last_sync', DateTime.now());

    debugPrint('✅ ${games.length} jogos cacheados');
  }

  /// Busca jogos por plataforma (muito mais rápido que JSON)
  static List<GameCacheModel> getGamesByPlatform(String platform) {
    if (_gamesBox == null) return [];

    return _gamesBox!.values
        .where((game) => game.platform == platform && !game.isExpired())
        .toList();
  }

  /// Busca jogos favoritos
  static List<GameCacheModel> getFavoriteGames() {
    if (_gamesBox == null) return [];

    return _gamesBox!.values
        .where((game) => game.isFavorite && !game.isExpired())
        .toList();
  }

  /// Busca todos os jogos não expirados
  static List<GameCacheModel> getAllGames() {
    if (_gamesBox == null) return [];

    return _gamesBox!.values.where((game) => !game.isExpired()).toList();
  }

  /// Marca/desmarca jogo como favorito
  static Future<void> toggleGameFavorite(String gameId) async {
    if (_gamesBox == null) return;

    final game = _gamesBox!.get(gameId);
    if (game != null) {
      final updatedGame = game.copyWith(isFavorite: !game.isFavorite);
      await _gamesBox!.put(gameId, updatedGame);
    }
  }

  /// Verifica se precisa sincronizar jogos
  static Future<bool> needsGameSync({
    Duration maxAge = const Duration(hours: 6),
  }) async {
    final lastSync = await _getCacheMetadata('games_last_sync');
    if (lastSync == null) return true;

    return DateTime.now().difference(lastSync) > maxAge;
  }

  // ====== USER CACHE ======

  /// Salva dados do usuário
  static Future<void> cacheUser(UserCacheModel user) async {
    if (_usersBox == null) throw Exception('Cache não inicializado');

    await _usersBox!.put('current_user', user);
    await _updateCacheMetadata('user_last_sync', DateTime.now());

    debugPrint('✅ Usuário ${user.name} cacheado');
  }

  /// Recupera usuário atual do cache
  static UserCacheModel? getCurrentUser() {
    if (_usersBox == null) return null;

    final user = _usersBox!.get('current_user');
    if (user != null && user.isExpired()) {
      _usersBox!.delete('current_user');
      return null;
    }

    return user;
  }

  // ====== SECURE STORAGE (tokens, dados sensíveis) ======

  /// Salva token de forma segura
  static Future<void> saveSecureToken(String key, String token) async {
    await _secureStorage.write(key: key, value: token);
  }

  /// Recupera token seguro
  static Future<String?> getSecureToken(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Remove token seguro
  static Future<void> removeSecureToken(String key) async {
    await _secureStorage.delete(key: key);
  }

  // ====== PREFERENCES (configurações simples) ======

  /// Salva preferência boolean
  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Recupera preferência boolean
  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  /// Salva preferência string
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Recupera preferência string
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // ====== METADATA E UTILIDADES ======

  /// Atualiza metadados de cache
  static Future<void> _updateCacheMetadata(
    String key,
    DateTime timestamp,
  ) async {
    await _metadataBox?.put(key, timestamp.millisecondsSinceEpoch);
  }

  /// Recupera metadados de cache
  static Future<DateTime?> _getCacheMetadata(String key) async {
    final timestamp = _metadataBox?.get(key);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  /// Limpa cache expirado (manutenção)
  static Future<void> cleanExpiredCache() async {
    debugPrint('🧹 Limpando cache expirado...');

    int cleaned = 0;

    // Limpar jogos expirados
    if (_gamesBox != null) {
      final expiredGames = _gamesBox!.values
          .where((game) => game.isExpired())
          .toList();

      for (final game in expiredGames) {
        await game.delete();
        cleaned++;
      }
    }

    // Limpar usuários expirados
    if (_usersBox != null) {
      final currentUser = _usersBox!.get('current_user');
      if (currentUser != null && currentUser.isExpired()) {
        await _usersBox!.delete('current_user');
        cleaned++;
      }
    }

    debugPrint('✅ $cleaned entradas de cache expirado removidas');
  }

  /// Estatísticas do cache para debugging
  static Map<String, dynamic> getCacheStats() {
    return {
      'games_count': _gamesBox?.length ?? 0,
      'users_count': _usersBox?.length ?? 0,
      'metadata_count': _metadataBox?.length ?? 0,
      'last_cleanup': _getCacheMetadata('last_cleanup'),
    };
  }

  /// Limpa todo o cache (logout)
  static Future<void> clearAllCache() async {
    debugPrint('🗑️ Limpando todo o cache...');

    await _gamesBox?.clear();
    await _usersBox?.clear();
    await _metadataBox?.clear();
    await _prefs?.clear();
    await _secureStorage.deleteAll();

    debugPrint('✅ Todo o cache foi limpo');
  }

  /// Fecha todas as conexões (cleanup)
  static Future<void> dispose() async {
    await _gamesBox?.close();
    await _usersBox?.close();
    await _metadataBox?.close();
  }
}
