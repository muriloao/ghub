import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/steam_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/auth/platform_auth_service.dart';
import '../../../../core/auth/auth_helpers.dart';
import '../models/steam_user_model.dart';
import '../../../auth/data/models/auth_result_model.dart';
import '../../../auth/data/models/user_model.dart';

class SteamIntegrationService extends PlatformAuthService {
  final Dio _dio;
  BuildContext? _context;

  SteamIntegrationService(this._dio);

  // Injeta contexto quando necessário
  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  String get platformName => 'Steam';

  @override
  String get platformIcon => 'assets/icons/steam.svg';

  @override
  int get platformColor => 0xFF171a21; // Steam dark blue

  @override
  bool validateConfiguration() {
    return SteamConfig.apiKey != null && SteamConfig.apiKey!.isNotEmpty;
  }

  @override
  Future<AuthResultModel?> authenticate() async {
    if (!validateConfiguration()) {
      throw const AuthenticationException(
        message:
            'Steam API Key não configurada. Configure STEAM_API_KEY no .env',
      );
    }

    // Obter contexto do Navigator global se disponível
    final BuildContext? context =
        _context ?? WidgetsBinding.instance.rootElement;

    if (context == null) {
      throw const AuthenticationException(
        message:
            'Context não disponível. Use setContext() ou certifique-se de que o app está renderizado',
      );
    }

    try {
      final nonce = PKCEHelper.generateSecureNonce();
      final authUrl = _buildSteamAuthUrl(nonce);

      // Abrir no navegador externo
      if (await canLaunchUrl(Uri.parse(authUrl))) {
        await launchUrl(Uri.parse(authUrl), mode: LaunchMode.inAppBrowserView);

        // Aguardar callback via deep link
        // O callback será processado pela SteamCallbackPage via deep link
      } else {
        throw const AuthenticationException(
          message: 'Não foi possível abrir o navegador',
        );
      }
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(message: 'Erro na autenticação Steam: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    // TODO: Implementar logout/disconnect do Steam
    // Remove tokens locais, limpa cache, etc.
  }

  @override
  Future<bool> refreshToken() async {
    // Steam não usa refresh tokens no OpenID
    return false;
  }

  @override
  Future<bool> isAuthenticated() async {
    // TODO: Verificar se existe token válido armazenado
    return false;
  }

  /// Método legacy para compatibilidade
  Future<AuthResultModel?> connectSteamForSync(BuildContext context) async {
    setContext(context);
    return authenticate();
  }

  String _buildSteamAuthUrl(String nonce) {
    final returnUrl = '${SteamConfig.returnUrl}?nonce=$nonce';

    final params = {
      'openid.ns': SteamConfig.ns,
      'openid.mode': SteamConfig.mode,
      'openid.return_to': returnUrl,
      'openid.realm': SteamConfig.realm,
      'openid.identity': SteamConfig.identity,
      'openid.claimed_id': SteamConfig.claimedId,
    };

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return '${SteamConfig.steamOpenIdUrl}/login?$queryString';
  }

  /// Completa a conexão Steam usando um Steam ID obtido via deep link
  Future<AuthResultModel> completeSteamConnectionWithSteamId(
    String steamId,
  ) async {
    try {
      if (!validateConfiguration()) {
        throw const AuthenticationException(
          message: 'Steam API Key não configurada',
        );
      }

      // Buscar dados do usuário Steam
      final steamUser = await _fetchSteamUserData(steamId);

      // Converter para nosso formato interno
      return _createAuthResult(steamUser);
    } catch (e) {
      if (e is AuthenticationException || e is ServerException) rethrow;
      throw AuthenticationException(
        message: 'Erro ao completar conexão Steam: $e',
      );
    }
  }

  Future<SteamUserModel> _fetchSteamUserData(String steamId) async {
    try {
      final response = await _dio.get(
        SteamConfig.getPlayerSummariesUrl,
        queryParameters: {'key': SteamConfig.apiKey, 'steamids': steamId},
      );

      if (response.statusCode == 200) {
        final steamResponse = SteamPlayersResponse.fromJson(response.data);

        if (steamResponse.response.players.isEmpty) {
          throw const ServerException(message: 'Usuário Steam não encontrado');
        }

        return steamResponse.response.players.first;
      } else {
        throw ServerException(
          message: 'Erro ao buscar dados do Steam: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: 'Erro de conexão com Steam API: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'Erro inesperado ao buscar dados Steam: $e',
      );
    }
  }

  AuthResultModel _createAuthResult(SteamUserModel steamUser) {
    final now = DateTime.now();

    // Criar usuário interno baseado nos dados Steam
    final user = UserModel(
      id: 'steam_${steamUser.steamid}',
      email: '${steamUser.steamid}@steam.local', // Steam não fornece email
      name: steamUser.personaname,
      avatarUrl: steamUser.avatarfull,
      createdAt: now,
    );

    // TODO: Implementar geração de tokens JWT reais
    final accessToken = _generateToken('access', steamUser.steamid);
    final refreshToken = _generateToken('refresh', steamUser.steamid);

    return AuthResultModel(
      userModel: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  String _generateToken(String type, String steamId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = '$type:$steamId:$timestamp';
    final bytes = utf8.encode(data);
    return base64Encode(bytes);
  }
}
