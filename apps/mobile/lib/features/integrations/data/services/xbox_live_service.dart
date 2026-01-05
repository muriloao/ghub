import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/config/xbox_config.dart';

/// Modelo de dados do usuário Xbox
class XboxUser {
  final String xuid;
  final String gamertag;
  final String? avatarUrl;
  final int gamerscore;
  final String? displayName;

  const XboxUser({
    required this.xuid,
    required this.gamertag,
    this.avatarUrl,
    required this.gamerscore,
    this.displayName,
  });

  factory XboxUser.fromJson(Map<String, dynamic> json) {
    return XboxUser(
      xuid: json['xuid']?.toString() ?? '',
      gamertag: json['gamertag']?.toString() ?? '',
      avatarUrl: json['profilePicture']?.toString(),
      gamerscore: json['gamerscore'] ?? 0,
      displayName: json['displayName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'xuid': xuid,
      'gamertag': gamertag,
      'profilePicture': avatarUrl,
      'gamerscore': gamerscore,
      'displayName': displayName,
    };
  }
}

/// Modelo de dados de games Xbox
class XboxGame {
  final String titleId;
  final String name;
  final String? imageUrl;
  final int achievementsUnlocked;
  final int totalAchievements;
  final int gamerscore;
  final DateTime? lastPlayedDate;

  const XboxGame({
    required this.titleId,
    required this.name,
    this.imageUrl,
    required this.achievementsUnlocked,
    required this.totalAchievements,
    required this.gamerscore,
    this.lastPlayedDate,
  });

  factory XboxGame.fromJson(Map<String, dynamic> json) {
    return XboxGame(
      titleId: json['titleId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['displayImage']?.toString(),
      achievementsUnlocked: json['currentAchievements'] ?? 0,
      totalAchievements: json['totalAchievements'] ?? 0,
      gamerscore: json['currentGamerscore'] ?? 0,
      lastPlayedDate: json['lastUnlock'] != null
          ? DateTime.tryParse(json['lastUnlock'])
          : null,
    );
  }
}

/// Serviço de autenticação e dados do Xbox Live
class XboxLiveService {
  final Dio _dio;

  XboxLiveService(this._dio);

  /// Inicia o processo de autenticação Xbox Live
  Future<void> authenticateWithXbox(BuildContext context) async {
    // Validar configurações
    if (!XboxConfig.isConfigured) {
      throw AuthenticationException(message: XboxConfig.configurationError);
    }

    // Gerar state para segurança
    final state = _generateState();

    // Construir URL de autenticação
    final authUrl = _buildXboxAuthUrl(state);

    try {
      // Abrir browser para autenticação
      await _launchXboxAuth(context, authUrl, state);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(message: 'Erro na autenticação Xbox: $e');
    }
  }

  /// Completa a autenticação com o código recebido do callback
  Future<XboxUser> completeAuthenticationWithCode(String code) async {
    try {
      // 1. Trocar código por access token
      final accessToken = await _exchangeCodeForToken(code);

      // 2. Autenticar com Xbox Live
      final xblToken = await _authenticateXboxLive(accessToken);

      // 3. Obter XSTS token
      final xstsData = await _getXSTSToken(xblToken);

      // 4. Buscar dados do perfil
      final user = await _fetchUserProfile(
        xstsData['token'],
        xstsData['userHash'],
      );

      return user;
    } catch (e) {
      throw AuthenticationException(
        message: 'Erro ao completar autenticação Xbox: $e',
      );
    }
  }

  /// Busca jogos do usuário Xbox
  Future<List<XboxGame>> fetchUserGames(String xuid) async {
    try {
      // Implementação simplificada - em produção usaria Xbox Live API
      // Retorna dados mock por enquanto
      return _getMockXboxGames();
    } catch (e) {
      throw Exception('Erro ao buscar jogos Xbox: $e');
    }
  }

  String _buildXboxAuthUrl(String state) {
    final params = {
      'client_id': XboxConfig.clientId,
      'response_type': 'code',
      'redirect_uri': XboxConfig.redirectUri,
      'scope': XboxConfig.scopes,
      'state': state,
      'response_mode': 'query',
    };

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return '${XboxConfig.authUrl}?$queryString';
  }

  Future<void> _launchXboxAuth(
    BuildContext context,
    String authUrl,
    String state,
  ) async {
    try {
      final uri = Uri.parse(authUrl);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(showTitle: true),
      );

      if (!launched) {
        throw const AuthenticationException(
          message: 'Não foi possível abrir o navegador para autenticação Xbox',
        );
      }
    } catch (e) {
      throw AuthenticationException(
        message: 'Erro ao abrir autenticação Xbox: $e',
      );
    }
  }

  Future<String> _exchangeCodeForToken(String code) async {
    final response = await _dio.post(
      XboxConfig.tokenUrl,
      data: {
        'client_id': XboxConfig.clientId,
        'client_secret': XboxConfig.clientSecret,
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': XboxConfig.redirectUri,
      },
      options: Options(contentType: 'application/x-www-form-urlencoded'),
    );

    if (response.statusCode != 200) {
      throw AuthenticationException(message: 'Erro ao trocar código por token');
    }

    return response.data['access_token'];
  }

  Future<String> _authenticateXboxLive(String accessToken) async {
    final response = await _dio.post(
      XboxConfig.xboxLiveUrl,
      data: {
        'Properties': {
          'AuthMethod': 'RPS',
          'SiteName': 'user.auth.xboxlive.com',
          'RpsTicket': 'd=$accessToken',
        },
        'RelyingParty': 'http://auth.xboxlive.com',
        'TokenType': 'JWT',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw AuthenticationException(message: 'Erro na autenticação Xbox Live');
    }

    return response.data['Token'];
  }

  Future<Map<String, dynamic>> _getXSTSToken(String xblToken) async {
    final response = await _dio.post(
      XboxConfig.xstsUrl,
      data: {
        'Properties': {
          'SandboxId': 'RETAIL',
          'UserTokens': [xblToken],
        },
        'RelyingParty': 'rp://api.minecraftservices.com/',
        'TokenType': 'JWT',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw AuthenticationException(message: 'Erro ao obter XSTS token');
    }

    final userHash = response.data['DisplayClaims']['xui'][0]['uhs'];
    return {'token': response.data['Token'], 'userHash': userHash};
  }

  Future<XboxUser> _fetchUserProfile(String xstsToken, String userHash) async {
    final response = await _dio.get(
      '${XboxConfig.profileUrl}?settings=Gamertag,GameDisplayPicRaw,Gamerscore,ModernGamertag',
      options: Options(
        headers: {
          'Authorization': 'XBL3.0 x=$userHash;$xstsToken',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw AuthenticationException(message: 'Erro ao buscar perfil Xbox');
    }

    final profileData = response.data['profileUsers'][0]['settings'];

    return XboxUser(
      xuid: response.data['profileUsers'][0]['id'],
      gamertag: _getSettingValue(profileData, 'Gamertag') ?? 'Unknown',
      avatarUrl: _getSettingValue(profileData, 'GameDisplayPicRaw'),
      gamerscore:
          int.tryParse(_getSettingValue(profileData, 'Gamerscore') ?? '0') ?? 0,
      displayName: _getSettingValue(profileData, 'ModernGamertag'),
    );
  }

  String? _getSettingValue(List<dynamic> settings, String settingId) {
    try {
      final setting = settings.firstWhere((s) => s['id'] == settingId);
      return setting['value'];
    } catch (e) {
      return null;
    }
  }

  String _generateState() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  List<XboxGame> _getMockXboxGames() {
    return [
      XboxGame(
        titleId: '219630713',
        name: 'Halo Infinite',
        imageUrl:
            'https://store-images.s-microsoft.com/image/apps.7088.13727851868390641.c6c36cee-6446-4b2e-9ca0-9dba5cbf0003.42329ce6-b6c9-4e17-9b82-be2d68a88b0c',
        achievementsUnlocked: 25,
        totalAchievements: 119,
        gamerscore: 450,
        lastPlayedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      XboxGame(
        titleId: '1063463608',
        name: 'Forza Horizon 5',
        imageUrl:
            'https://store-images.s-microsoft.com/image/apps.26461.13991066054487998.c18d0b39-1064-4741-9e18-816cd53ace35.b6db9e96-02ba-4a7f-b41a-13d7c8806ba6',
        achievementsUnlocked: 89,
        totalAchievements: 200,
        gamerscore: 1200,
        lastPlayedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      XboxGame(
        titleId: '1690971104',
        name: 'Microsoft Flight Simulator',
        imageUrl:
            'https://store-images.s-microsoft.com/image/apps.31966.13727852107967150.b8b2375e-4f0c-449c-9e98-37ad6d6c7b95.bd3ebc87-4b33-4f80-a2e9-e37e967c0b29',
        achievementsUnlocked: 15,
        totalAchievements: 1000,
        gamerscore: 350,
        lastPlayedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}
