import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
  });

  Future<String?> getCachedAccessToken();
  Future<String?> getCachedRefreshToken();
  Future<UserModel?> getCachedUser();
  Future<bool> isLoggedIn();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<void> cacheAuthData({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
  }) async {
    try {
      // Store tokens securely
      await secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: accessToken,
      );
      await secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: refreshToken,
      );

      // Store user data and login status
      await sharedPreferences.setString(
        AppConstants.userDataKey,
        json.encode(user.toJson()),
      );
      await sharedPreferences.setBool(AppConstants.isLoggedInKey, true);
    } catch (e) {
      throw CacheException(message: 'Erro ao salvar dados de autenticação');
    }
  }

  @override
  Future<String?> getCachedAccessToken() async {
    try {
      return await secureStorage.read(key: AppConstants.accessTokenKey);
    } catch (e) {
      throw CacheException(message: 'Erro ao recuperar token de acesso');
    }
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    try {
      return await secureStorage.read(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Erro ao recuperar token de atualização');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userString = sharedPreferences.getString(AppConstants.userDataKey);
      if (userString != null) {
        return UserModel.fromJson(json.decode(userString));
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Erro ao recuperar dados do usuário');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return sharedPreferences.getBool(AppConstants.isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: AppConstants.accessTokenKey);
      await secureStorage.delete(key: AppConstants.refreshTokenKey);
      await sharedPreferences.remove(AppConstants.userDataKey);
      await sharedPreferences.setBool(AppConstants.isLoggedInKey, false);
    } catch (e) {
      throw CacheException(message: 'Erro ao limpar cache');
    }
  }
}
