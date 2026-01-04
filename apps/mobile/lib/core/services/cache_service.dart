import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/domain/entities/auth_result.dart';

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
