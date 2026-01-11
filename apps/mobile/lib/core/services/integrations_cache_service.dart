import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Dados de uma plataforma conectada armazenados em cache
class CachedPlatformData {
  final String platformId;
  final String userId; // XUID para Xbox, Steam ID para Steam, etc.
  final String username;
  final String? avatarUrl;
  final Map<String, dynamic>? additionalData;
  final DateTime connectedAt;
  final DateTime lastSyncAt;

  const CachedPlatformData({
    required this.platformId,
    required this.userId,
    required this.username,
    this.avatarUrl,
    this.additionalData,
    required this.connectedAt,
    required this.lastSyncAt,
  });

  factory CachedPlatformData.fromJson(Map<String, dynamic> json) {
    return CachedPlatformData(
      platformId: json['platformId'],
      userId: json['userId'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      additionalData: json['additionalData'] != null
          ? Map<String, dynamic>.from(json['additionalData'])
          : null,
      connectedAt: DateTime.parse(json['connectedAt']),
      lastSyncAt: DateTime.parse(json['lastSyncAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platformId': platformId,
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'additionalData': additionalData,
      'connectedAt': connectedAt.toIso8601String(),
      'lastSyncAt': lastSyncAt.toIso8601String(),
    };
  }

  CachedPlatformData copyWith({
    String? platformId,
    String? userId,
    String? username,
    String? avatarUrl,
    Map<String, dynamic>? additionalData,
    DateTime? connectedAt,
    DateTime? lastSyncAt,
  }) {
    return CachedPlatformData(
      platformId: platformId ?? this.platformId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      additionalData: additionalData ?? this.additionalData,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}

/// Serviço de cache para integrações de plataformas
class IntegrationsCacheService {
  static const _storage = FlutterSecureStorage();

  // Keys para cache
  static const String _connectedPlatformsKey = 'connected_platforms';
  static const String _platformTokenPrefix = 'platform_token_';
  static const String _platformGamesPrefix = 'platform_games_';

  /// Cache das plataformas conectadas
  static Future<void> cachePlatformConnection({
    required String platformId,
    required String userId,
    required String username,
    String? avatarUrl,
    Map<String, dynamic>? additionalData,
    String? accessToken,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      // Criar dados da plataforma
      final platformData = CachedPlatformData(
        platformId: platformId,
        userId: userId,
        username: username,
        avatarUrl: avatarUrl,
        additionalData: additionalData,
        connectedAt: now,
        lastSyncAt: now,
      );

      // Buscar plataformas conectadas existentes
      final connectedPlatforms = await getConnectedPlatforms();

      // Atualizar ou adicionar nova plataforma
      final updatedPlatforms = Map<String, CachedPlatformData>.from(
        connectedPlatforms,
      );
      updatedPlatforms[platformId] = platformData;

      // Salvar lista atualizada
      final platformsJson = updatedPlatforms.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      await prefs.setString(_connectedPlatformsKey, jsonEncode(platformsJson));

      // Salvar token de acesso de forma segura (se fornecido)
      if (accessToken != null) {
        await _storage.write(
          key: '$_platformTokenPrefix$platformId',
          value: accessToken,
        );
      }
    } catch (e) {
      throw Exception('Erro ao salvar cache da integração: $e');
    }
  }

  /// Recupera todas as plataformas conectadas
  static Future<Map<String, CachedPlatformData>> getConnectedPlatforms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final platformsJson = prefs.getString(_connectedPlatformsKey);

      if (platformsJson == null) return {};

      final platformsMap = jsonDecode(platformsJson) as Map<String, dynamic>;
      return platformsMap.map(
        (key, value) => MapEntry(
          key,
          CachedPlatformData.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return {};
    }
  }

  /// Verifica se uma plataforma está conectada
  static Future<bool> isPlatformConnected(String platformId) async {
    final connectedPlatforms = await getConnectedPlatforms();
    return connectedPlatforms.containsKey(platformId);
  }

  /// Recupera dados de uma plataforma específica
  static Future<CachedPlatformData?> getPlatformData(String platformId) async {
    final connectedPlatforms = await getConnectedPlatforms();
    return connectedPlatforms[platformId];
  }

  /// Recupera token de acesso de uma plataforma
  static Future<String?> getPlatformToken(String platformId) async {
    try {
      return await _storage.read(key: '$_platformTokenPrefix$platformId');
    } catch (e) {
      return null;
    }
  }

  /// Remove uma plataforma conectada
  static Future<bool> removePlatformConnection(String platformId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Buscar plataformas conectadas
      final connectedPlatforms = await getConnectedPlatforms();

      // Remover plataforma
      connectedPlatforms.remove(platformId);

      // Salvar lista atualizada
      final platformsJson = connectedPlatforms.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      await prefs.setString(_connectedPlatformsKey, jsonEncode(platformsJson));

      // Remover token de acesso
      await _storage.delete(key: '$_platformTokenPrefix$platformId');

      // Remover cache de jogos
      await _storage.delete(key: '$_platformGamesPrefix$platformId');

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cache de jogos de uma plataforma
  static Future<void> cachePlatformGames({
    required String platformId,
    required List<Map<String, dynamic>> games,
  }) async {
    try {
      await _storage.write(
        key: '$_platformGamesPrefix$platformId',
        value: jsonEncode(games),
      );
    } catch (e) {
      throw Exception('Erro ao salvar cache de jogos: $e');
    }
  }

  /// Recupera jogos em cache de uma plataforma
  static Future<List<Map<String, dynamic>>?> getCachedPlatformGames(
    String platformId,
  ) async {
    try {
      final gamesJson = await _storage.read(
        key: '$_platformGamesPrefix$platformId',
      );
      if (gamesJson == null) return null;

      final gamesList = jsonDecode(gamesJson) as List<dynamic>;
      return gamesList.map((game) => Map<String, dynamic>.from(game)).toList();
    } catch (e) {
      return null;
    }
  }

  /// Atualiza timestamp da última sincronização
  static Future<void> updateLastSync(String platformId) async {
    try {
      final platformData = await getPlatformData(platformId);
      if (platformData == null) return;

      final updatedData = platformData.copyWith(lastSyncAt: DateTime.now());

      await cachePlatformConnection(
        platformId: updatedData.platformId,
        userId: updatedData.userId,
        username: updatedData.username,
        avatarUrl: updatedData.avatarUrl,
        additionalData: updatedData.additionalData,
      );
    } catch (e) {
      // Silently fail - não é crítico
    }
  }

  /// Limpa cache de uma plataforma específica
  static Future<bool> clearPlatformCache(String platformId) async {
    return await removePlatformConnection(platformId);
  }

  /// Limpa todo o cache de integrações
  static Future<bool> clearAllIntegrationsCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_connectedPlatformsKey);

      // Remove todos os tokens e cache de jogos
      final connectedPlatforms = await getConnectedPlatforms();
      for (final platformId in connectedPlatforms.keys) {
        await _storage.delete(key: '$_platformTokenPrefix$platformId');
        await _storage.delete(key: '$_platformGamesPrefix$platformId');
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
