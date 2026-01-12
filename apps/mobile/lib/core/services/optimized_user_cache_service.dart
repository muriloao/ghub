import 'package:flutter/foundation.dart';
import '../cache/cache_manager.dart';
import '../cache/models/user_cache_model.dart';
import '../../features/auth/domain/entities/user.dart';

/// Serviço otimizado para cache de dados de usuários
class OptimizedUserCacheService {
  /// Cache dados do usuário atual
  static Future<void> cacheCurrentUser(User user) async {
    final userCache = UserCacheModel.fromUser(user);
    await CacheManager.cacheUser(userCache);
  }

  /// Recupera usuário atual do cache
  static UserCacheModel? getCurrentUser() {
    return CacheManager.getCurrentUser();
  }

  /// Verifica se há usuário válido no cache
  static bool hasValidUserCache() {
    final user = getCurrentUser();
    return user != null && !user.isExpired();
  }

  /// Atualiza timestamp de último acesso
  static Future<void> updateLastAccess() async {
    final currentUser = getCurrentUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(cachedAt: DateTime.now());
      await CacheManager.cacheUser(updatedUser);
    }
  }

  /// Cache de dados sensíveis (tokens)
  static Future<void> cacheAuthTokens({
    required String accessToken,
    String? refreshToken,
    String? steamId,
  }) async {
    await CacheManager.saveSecureToken('access_token', accessToken);

    if (refreshToken != null) {
      await CacheManager.saveSecureToken('refresh_token', refreshToken);
    }

    if (steamId != null) {
      await CacheManager.saveSecureToken('steam_id', steamId);
    }

    // Salvar status de login nas preferências
    await CacheManager.setBool('is_logged_in', true);
    await CacheManager.setString(
      'last_login',
      DateTime.now().toIso8601String(),
    );
  }

  /// Recupera tokens de autenticação
  static Future<Map<String, String?>> getAuthTokens() async {
    return {
      'accessToken': await CacheManager.getSecureToken('access_token'),
      'refreshToken': await CacheManager.getSecureToken('refresh_token'),
      'steamId': await CacheManager.getSecureToken('steam_id'),
    };
  }

  /// Verifica se está logado
  static bool isLoggedIn() {
    return CacheManager.getBool('is_logged_in');
  }

  /// Cache de preferências do usuário
  static Future<void> cacheUserPreferences(UserPreferences preferences) async {
    await CacheManager.setBool('dark_mode', preferences.darkMode);
    await CacheManager.setBool('notifications', preferences.notifications);
    await CacheManager.setString('language', preferences.language);
    await CacheManager.setString('theme_color', preferences.themeColor);
  }

  /// Recupera preferências do usuário
  static UserPreferences getUserPreferences() {
    return UserPreferences(
      darkMode: CacheManager.getBool('dark_mode'),
      notifications: CacheManager.getBool('notifications', defaultValue: true),
      language: CacheManager.getString('language') ?? 'pt-BR',
      themeColor: CacheManager.getString('theme_color') ?? 'blue',
    );
  }

  /// Limpa cache do usuário (logout)
  static Future<void> clearUserCache() async {
    // Remove tokens sensíveis
    await CacheManager.removeSecureToken('access_token');
    await CacheManager.removeSecureToken('refresh_token');
    await CacheManager.removeSecureToken('steam_id');

    // Remove status de login
    await CacheManager.setBool('is_logged_in', false);

    // Remove usuário do cache usando CacheManager
    // O CacheManager já gerencia isso internamente
    debugPrint('Cache do usuário limpo');
  }

  /// Migra dados legados do SharedPreferences
  static Future<void> migrateLegacyUserCache() async {
    // Implementar migração se necessário
    // Esta função será executada uma única vez
  }
}

/// Classe para preferências do usuário
class UserPreferences {
  final bool darkMode;
  final bool notifications;
  final String language;
  final String themeColor;

  UserPreferences({
    this.darkMode = false,
    this.notifications = true,
    this.language = 'pt-BR',
    this.themeColor = 'blue',
  });

  UserPreferences copyWith({
    bool? darkMode,
    bool? notifications,
    String? language,
    String? themeColor,
  }) {
    return UserPreferences(
      darkMode: darkMode ?? this.darkMode,
      notifications: notifications ?? this.notifications,
      language: language ?? this.language,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}
