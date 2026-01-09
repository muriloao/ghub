import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:ghub_mobile/features/auth/data/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/steam_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/data/models/steam_user_model.dart';
import '../../../auth/data/models/auth_result_model.dart';

class SteamIntegrationService {
  final Dio _dio;

  SteamIntegrationService(this._dio);

  /// Conecta conta Steam para sincronização de jogos
  Future<void> connectSteamForSync(BuildContext context) async {
    // Validar se a API key está configurada
    if (SteamConfig.apiKey == null || SteamConfig.apiKey!.isEmpty) {
      throw const AuthenticationException(
        message:
            'Steam API Key não configurada. Configure em SteamConfig.apiKey',
      );
    }

    // Gerar nonce e criar URL de retorno
    final nonce = _generateNonce();
    final returnUrl = '${SteamConfig.returnUrl}?nonce=$nonce';

    // Construir URL de autenticação Steam
    final authUrl = _buildSteamAuthUrl(returnUrl);

    try {
      // Abrir browser in-app e aguardar callback via deep link
      await _launchSteamConnection(context, authUrl, nonce);

      // // tela da steam que deve fazer
      // if (steamId == null) {
      //   throw const AuthenticationException(
      //     message: 'Autenticação Steam cancelada ou falhou',
      //   );
      // }

      // // Buscar dados do usuário Steam
      // final steamUser = await _fetchSteamUserData(steamId);

      // // Converter para nosso formato interno
      // return _createAuthResult(steamUser);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(message: 'Erro na autenticação Steam: $e');
    }
  }

  String _buildSteamAuthUrl(String returnUrl) {
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

  Future<void> _launchSteamConnection(
    BuildContext context,
    String authUrl,
    String nonce,
  ) async {
    try {
      // Abrir URL no browser in-app
      final uri = Uri.parse(authUrl);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(showTitle: true),
      );

      if (!launched) {
        throw const AuthenticationException(
          message: 'Não foi possível abrir o navegador para autenticação',
        );
      }

      // Retorna null - o deep link será capturado pelo DeepLinkService
      // e processado na SteamCallbackPage
      // return '76561198094544213'; // Simular Steam ID para teste
    } catch (e) {
      throw AuthenticationException(
        message: 'Erro ao iniciar conexão Steam: $e',
      );
    }
  }

  /// Completa a conexão Steam usando um Steam ID obtido via deep link
  Future<AuthResultModel> completeSteamConnectionWithSteamId(
    String steamId,
  ) async {
    try {
      // Validar se a API key está configurada
      if (SteamConfig.apiKey == null || SteamConfig.apiKey!.isEmpty) {
        throw const AuthenticationException(
          message:
              'Steam API Key não configurada. Configure em SteamConfig.apiKey',
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

  String _generateNonce() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _generateToken(String type, String steamId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = '$type:$steamId:$timestamp';
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return base64Url.encode(hash.bytes);
  }
}
