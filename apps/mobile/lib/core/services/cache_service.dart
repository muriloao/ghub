import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/domain/entities/auth_result.dart';
import '../../features/games/data/models/steam_game_model.dart';
import '../../features/integrations/data/services/xbox_live_service.dart';

/// Serviço de cache para dados da aplicação
/// Utiliza Flutter Secure Storage para dados sensíveis e SharedPreferences para outros dados
class CacheService {
  static const _storage = FlutterSecureStorage();

  // Keys para cache
  static const String _userCacheKey = 'user_cache';
  static const String _authTokenKey = 'auth_token';
  static const String _steamIdKey = 'steam_id';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _lastLoginTimestampKey = 'last_login_timestamp';

  // Keys para cache de plataformas
  static const String _steamGamesKey = 'steam_games';
  static const String _steamUserKey = 'steam_user';
  static const String _steamLastSyncKey = 'steam_last_sync';
  static const String _xboxGamesKey = 'xbox_games';
  static const String _xboxUserKey = 'xbox_user';
  static const String _xboxLastSyncKey = 'xbox_last_sync';
  static const String _epicGamesKey = 'epic_games';
  static const String _epicUserKey = 'epic_user';
  static const String _epicLastSyncKey = 'epic_last_sync';

  /// Cache dos dados do usuário após login
  static Future<void> cacheUserData({
    required User user,
    required String? authToken,
    required String? steamId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Cache do usuário (dados não-sensíveis)
      await prefs.setString(_userCacheKey, jsonEncode(user.toJson()));

      // Cache de dados sensíveis usando Secure Storage
      if (authToken != null) {
        await _storage.write(key: _authTokenKey, value: authToken);
      }

      if (steamId != null) {
        await _storage.write(key: _steamIdKey, value: steamId);
      }

      // Marca como logado e timestamp
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setInt(
        _lastLoginTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw Exception('Erro ao salvar cache do usuário: $e');
    }
  }

  /// Recupera os dados do usuário do cache
  static Future<CachedUserData?> getCachedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Verifica se está logado
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      if (!isLoggedIn) return null;

      // Recupera dados do usuário
      final userJson = prefs.getString(_userCacheKey);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final user = User.fromJson(userMap);

      // Recupera dados sensíveis
      final authToken = await _storage.read(key: _authTokenKey);
      final steamId = await _storage.read(key: _steamIdKey);
      final lastLoginTimestamp = prefs.getInt(_lastLoginTimestampKey);

      return CachedUserData(
        user: user,
        authToken: authToken,
        steamId: steamId,
        lastLoginTimestamp: lastLoginTimestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(lastLoginTimestamp)
            : null,
      );
    } catch (e) {
      // Em caso de erro, limpa cache corrompido
      await clearUserCache();
      return null;
    }
  }

  /// Método de compatibilidade que retorna dados como Map
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final cachedData = await getCachedUserData();
      if (cachedData == null) return null;

      return {
        'user': cachedData.user.toJson(),
        'authToken': cachedData.authToken,
        'steamId': cachedData.steamId,
        'lastLoginTimestamp':
            cachedData.lastLoginTimestamp?.millisecondsSinceEpoch,
      };
    } catch (e) {
      return null;
    }
  }

  /// Verifica se existe cache de usuário válido
  static Future<bool> hasValidUserCache({
    Duration maxAge = const Duration(days: 30),
  }) async {
    try {
      final cachedData = await getCachedUserData();
      if (cachedData == null) return false;

      // Verifica se o cache não está muito antigo
      if (cachedData.lastLoginTimestamp != null) {
        final now = DateTime.now();
        final diff = now.difference(cachedData.lastLoginTimestamp!);
        if (diff > maxAge) {
          await clearUserCache();
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Atualiza o timestamp do último login
  static Future<void> updateLastLoginTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        _lastLoginTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      // Silently fail - não é crítico
    }
  }

  /// Limpa todo o cache do usuário (logout)
  static Future<void> clearUserCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove dados do SharedPreferences
      await prefs.remove(_userCacheKey);
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_lastLoginTimestampKey);

      // Remove dados sensíveis do Secure Storage
      await _storage.delete(key: _authTokenKey);
      await _storage.delete(key: _steamIdKey);
    } catch (e) {
      throw Exception('Erro ao limpar cache do usuário: $e');
    }
  }

  /// Limpa apenas dados sensíveis (manter user data para debug)
  static Future<void> clearSensitiveData() async {
    try {
      await _storage.delete(key: _authTokenKey);
      await _storage.delete(key: _steamIdKey);
    } catch (e) {
      throw Exception('Erro ao limpar dados sensíveis: $e');
    }
  }

  /// Limpa todo o cache da aplicação
  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _storage.deleteAll();
    } catch (e) {
      throw Exception('Erro ao limpar cache completo: $e');
    }
  }
}

/// Dados do usuário armazenados em cache
class CachedUserData {
  final User user;
  final String? authToken;
  final String? steamId;
  final DateTime? lastLoginTimestamp;

  const CachedUserData({
    required this.user,
    this.authToken,
    this.steamId,
    this.lastLoginTimestamp,
  });

  /// Converte para AuthResult para compatibilidade
  AuthResult toAuthResult() {
    return AuthResult(
      user: user,
      accessToken: authToken ?? '',
      refreshToken: '', // Para Steam, não temos refresh token
    );
  }
}

/// Enumeração das plataformas suportadas
enum Platform { steam, xbox, epic }

/// Dados de cache de uma plataforma
class PlatformCacheData {
  final Platform platform;
  final Map<String, dynamic>? userData;
  final List<Map<String, dynamic>>? gamesData;
  final DateTime? lastSync;

  const PlatformCacheData({
    required this.platform,
    this.userData,
    this.gamesData,
    this.lastSync,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform.name,
      'userData': userData,
      'gamesData': gamesData,
      'lastSync': lastSync?.millisecondsSinceEpoch,
    };
  }

  factory PlatformCacheData.fromJson(Map<String, dynamic> json) {
    return PlatformCacheData(
      platform: Platform.values.firstWhere(
        (p) => p.name == json['platform'],
        orElse: () => Platform.steam,
      ),
      userData: json['userData'] as Map<String, dynamic>?,
      gamesData: (json['gamesData'] as List?)?.cast<Map<String, dynamic>>(),
      lastSync: json['lastSync'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSync'])
          : null,
    );
  }

  bool isExpired({Duration maxAge = const Duration(hours: 6)}) {
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync!) > maxAge;
  }
}

/// Extensão do CacheService para cache de plataformas
extension PlatformCacheExtension on CacheService {
  /// Salva dados do Steam no cache
  static Future<void> cacheSteamData({
    Map<String, dynamic>? userData,
    List<SteamGameModel>? games,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      if (userData != null) {
        await prefs.setString(CacheService._steamUserKey, jsonEncode(userData));
      }

      if (games != null) {
        final gamesJson = games.map((game) => game.toJson()).toList();
        await prefs.setString(
          CacheService._steamGamesKey,
          jsonEncode(gamesJson),
        );
      }

      await prefs.setInt(
        CacheService._steamLastSyncKey,
        now.millisecondsSinceEpoch,
      );
    } catch (e) {
      throw Exception('Erro ao salvar cache Steam: $e');
    }
  }

  /// Salva dados do Xbox no cache
  static Future<void> cacheXboxData({
    XboxUser? userData,
    List<XboxGame>? games,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      if (userData != null) {
        await prefs.setString(
          CacheService._xboxUserKey,
          jsonEncode(userData.toJson()),
        );
      }

      if (games != null) {
        final gamesJson = games.map((game) => game.toJson()).toList();
        await prefs.setString(
          CacheService._xboxGamesKey,
          jsonEncode(gamesJson),
        );
      }

      await prefs.setInt(
        CacheService._xboxLastSyncKey,
        now.millisecondsSinceEpoch,
      );
    } catch (e) {
      throw Exception('Erro ao salvar cache Xbox: $e');
    }
  }

  /// Salva dados do Epic Games no cache
  static Future<void> cacheEpicData({
    Map<String, dynamic>? userData,
    List<Map<String, dynamic>>? games,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      if (userData != null) {
        await prefs.setString(CacheService._epicUserKey, jsonEncode(userData));
      }

      if (games != null) {
        await prefs.setString(CacheService._epicGamesKey, jsonEncode(games));
      }

      await prefs.setInt(
        CacheService._epicLastSyncKey,
        now.millisecondsSinceEpoch,
      );
    } catch (e) {
      throw Exception('Erro ao salvar cache Epic: $e');
    }
  }

  /// Recupera dados do Steam do cache
  static Future<PlatformCacheData?> getSteamCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userDataJson = prefs.getString(CacheService._steamUserKey);
      final gamesDataJson = prefs.getString(CacheService._steamGamesKey);
      final lastSyncTimestamp = prefs.getInt(CacheService._steamLastSyncKey);

      Map<String, dynamic>? userData;
      List<Map<String, dynamic>>? gamesData;

      if (userDataJson != null) {
        userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      }

      if (gamesDataJson != null) {
        final gamesList = jsonDecode(gamesDataJson) as List;
        gamesData = gamesList.cast<Map<String, dynamic>>();
      }

      return PlatformCacheData(
        platform: Platform.steam,
        userData: userData,
        gamesData: gamesData,
        lastSync: lastSyncTimestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(lastSyncTimestamp)
            : null,
      );
    } catch (e) {
      return null;
    }
  }

  /// Recupera dados do Xbox do cache
  static Future<PlatformCacheData?> getXboxCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userDataJson = prefs.getString(CacheService._xboxUserKey);
      final gamesDataJson = prefs.getString(CacheService._xboxGamesKey);
      final lastSyncTimestamp = prefs.getInt(CacheService._xboxLastSyncKey);

      Map<String, dynamic>? userData;
      List<Map<String, dynamic>>? gamesData;

      if (userDataJson != null) {
        userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      }

      if (gamesDataJson != null) {
        final gamesList = jsonDecode(gamesDataJson) as List;
        gamesData = gamesList.cast<Map<String, dynamic>>();
      }

      return PlatformCacheData(
        platform: Platform.xbox,
        userData: userData,
        gamesData: gamesData,
        lastSync: lastSyncTimestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(lastSyncTimestamp)
            : null,
      );
    } catch (e) {
      return null;
    }
  }

  /// Recupera dados do Epic Games do cache
  static Future<PlatformCacheData?> getEpicCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userDataJson = prefs.getString(CacheService._epicUserKey);
      final gamesDataJson = prefs.getString(CacheService._epicGamesKey);
      final lastSyncTimestamp = prefs.getInt(CacheService._epicLastSyncKey);

      Map<String, dynamic>? userData;
      List<Map<String, dynamic>>? gamesData;

      if (userDataJson != null) {
        userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      }

      if (gamesDataJson != null) {
        final gamesList = jsonDecode(gamesDataJson) as List;
        gamesData = gamesList.cast<Map<String, dynamic>>();
      }

      return PlatformCacheData(
        platform: Platform.epic,
        userData: userData,
        gamesData: gamesData,
        lastSync: lastSyncTimestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(lastSyncTimestamp)
            : null,
      );
    } catch (e) {
      return null;
    }
  }

  /// Limpa cache de uma plataforma específica
  static Future<void> clearPlatformCache(Platform platform) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      switch (platform) {
        case Platform.steam:
          await prefs.remove(CacheService._steamUserKey);
          await prefs.remove(CacheService._steamGamesKey);
          await prefs.remove(CacheService._steamLastSyncKey);
          break;
        case Platform.xbox:
          await prefs.remove(CacheService._xboxUserKey);
          await prefs.remove(CacheService._xboxGamesKey);
          await prefs.remove(CacheService._xboxLastSyncKey);
          break;
        case Platform.epic:
          await prefs.remove(CacheService._epicUserKey);
          await prefs.remove(CacheService._epicGamesKey);
          await prefs.remove(CacheService._epicLastSyncKey);
          break;
      }
    } catch (e) {
      throw Exception('Erro ao limpar cache da plataforma: $e');
    }
  }

  /// Limpa cache de todas as plataformas
  static Future<void> clearAllPlatformCache() async {
    await Future.wait([
      clearPlatformCache(Platform.steam),
      clearPlatformCache(Platform.xbox),
      clearPlatformCache(Platform.epic),
    ]);
  }

  /// Verifica se o cache de uma plataforma é válido
  static Future<bool> isPlatformCacheValid(
    Platform platform, {
    Duration maxAge = const Duration(hours: 6),
  }) async {
    PlatformCacheData? cache;

    switch (platform) {
      case Platform.steam:
        cache = await getSteamCache();
        break;
      case Platform.xbox:
        cache = await getXboxCache();
        break;
      case Platform.epic:
        cache = await getEpicCache();
        break;
    }

    return cache != null && !cache.isExpired(maxAge: maxAge);
  }

  /// Recupera dados combinados de todas as plataformas
  static Future<Map<Platform, PlatformCacheData?>> getAllPlatformCache() async {
    final results = await Future.wait([
      getSteamCache(),
      getXboxCache(),
      getEpicCache(),
    ]);

    return {
      Platform.steam: results[0],
      Platform.xbox: results[1],
      Platform.epic: results[2],
    };
  }
}
