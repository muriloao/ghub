import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/epic_games_config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/epic_game_model.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

class EpicAuthService {
  final Dio _dio;

  EpicAuthService(this._dio);

  /// Inicia o processo de autenticação Epic Games OAuth2
  Future<void> authenticateWithEpic(BuildContext context) async {
    // Validar se as credenciais estão configuradas
    if (EpicGamesConfig.clientId == 'SEU_EPIC_CLIENT_ID_AQUI') {
      throw const AuthenticationException(
        message:
            'Epic Games Client ID não configurado. Configure em EpicGamesConfig.clientId',
      );
    }

    // Gerar state para segurança
    final state = _generateState();

    // Construir URL de autenticação
    final authUrl = EpicGamesConfig.buildAuthUrl(state: state);

    try {
      // Abrir browser in-app para autenticação
      await _launchEpicAuth(context, authUrl);

      // O callback será processado via deep link
      // Similar ao fluxo do Steam
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(
        message: 'Erro na autenticação Epic Games: $e',
      );
    }
  }

  /// Completa a autenticação Epic Games usando código de autorização
  Future<AuthResultModel> completeAuthenticationWithCode(
    String code,
    String state,
  ) async {
    try {
      // 1. Trocar código de autorização por tokens
      final tokenResponse = await _exchangeCodeForTokens(code);

      // 2. Buscar dados do usuário
      final epicUser = await _fetchEpicUserData(tokenResponse.accessToken);

      // 3. Converter para nosso formato interno
      return _createAuthResult(epicUser, tokenResponse.accessToken);
    } catch (e) {
      if (e is AuthenticationException || e is ServerException) rethrow;
      throw AuthenticationException(
        message: 'Erro ao completar autenticação Epic Games: $e',
      );
    }
  }

  /// Busca jogos do usuário Epic Games
  Future<List<EpicGameModel>> fetchUserGames(String accessToken) async {
    try {
      // Epic Games API para entitlements (jogos owned)
      final response = await _dio.get(
        EpicGamesConfig.entitlementsUrl,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> entitlementsData = response.data;
        final games = <EpicGameModel>[];

        // Para cada entitlement, buscar detalhes do jogo
        for (final entitlement in entitlementsData) {
          final gameDetails = await _fetchGameDetails(
            entitlement['catalogItemId'],
            accessToken,
          );
          if (gameDetails != null) {
            games.add(gameDetails);
          }
        }

        return games;
      } else {
        throw ServerException(
          message: 'Erro ao buscar jogos Epic Games: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: 'Erro de conexão com Epic Games API: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'Erro inesperado ao buscar jogos Epic Games: $e',
      );
    }
  }

  Future<void> _launchEpicAuth(BuildContext context, String authUrl) async {
    try {
      final uri = Uri.parse(authUrl);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(showTitle: true),
      );

      if (!launched) {
        throw const AuthenticationException(
          message:
              'Não foi possível abrir o navegador para autenticação Epic Games',
        );
      }
    } catch (e) {
      throw AuthenticationException(
        message: 'Erro ao abrir autenticação Epic Games: $e',
      );
    }
  }

  Future<EpicTokenResponse> _exchangeCodeForTokens(String code) async {
    try {
      final response = await _dio.post(
        EpicGamesConfig.tokenUrl,
        data: {
          'grant_type': 'authorization_code',
          'client_id': EpicGamesConfig.clientId,
          'client_secret': EpicGamesConfig.clientSecret,
          'redirect_uri': EpicGamesConfig.redirectUri,
          'code': code,
        },
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      if (response.statusCode == 200) {
        return EpicTokenResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao trocar código por tokens: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: 'Erro de rede ao trocar código por tokens: ${e.message}',
      );
    }
  }

  Future<EpicUserModel> _fetchEpicUserData(String accessToken) async {
    try {
      final response = await _dio.get(
        EpicGamesConfig.userInfoUrl,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        // Epic Games API retorna array com um usuário
        final List<dynamic> users = response.data;
        if (users.isNotEmpty) {
          return EpicUserModel.fromJson(users.first);
        } else {
          throw const ServerException(
            message: 'Usuário Epic Games não encontrado',
          );
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar dados do Epic Games: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: 'Erro de conexão com Epic Games API: ${e.message}',
      );
    }
  }

  Future<EpicGameModel?> _fetchGameDetails(
    String catalogItemId,
    String accessToken,
  ) async {
    try {
      final response = await _dio.get(
        '${EpicGamesConfig.catalogUrl}/$catalogItemId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return EpicGameModel.fromJson(response.data);
      } else {
        // Se não conseguir buscar detalhes de um jogo específico, apenas ignora
        return null;
      }
    } catch (e) {
      // Ignora erros individuais de jogos para não quebrar a lista completa
      return null;
    }
  }

  AuthResultModel _createAuthResult(
    EpicUserModel epicUser,
    String accessToken,
  ) {
    final now = DateTime.now();

    // Criar usuário interno baseado nos dados Epic Games
    final user = UserModel(
      id: 'epic_${epicUser.id}',
      email: epicUser.email ?? '${epicUser.id}@epic.local',
      name: epicUser.displayName,
      avatarUrl: epicUser.avatar,
      createdAt: now,
      updatedAt: now,
    );

    // Usar o access token real para Epic Games
    final refreshToken = _generateToken('refresh', epicUser.id);

    return AuthResultModel(
      userModel: user,
      accessToken: accessToken, // Usar o token real da Epic
      refreshToken: refreshToken,
    );
  }

  String _generateState() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _generateToken(String type, String epicUserId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = '$type:$epicUserId:$timestamp';
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return base64Url.encode(hash.bytes);
  }
}
