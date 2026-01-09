import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:ghub_mobile/features/auth/data/models/user_model.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/steam_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/data/models/steam_user_model.dart';
import '../../../auth/data/models/auth_result_model.dart';

class SteamIntegrationService {
  final Dio _dio;

  SteamIntegrationService(this._dio);

  /// Conecta conta Steam para sincronização de jogos
  Future<AuthResultModel?> connectSteamForSync(BuildContext context) async {
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
      // Usar InAppWebView para capturar callback diretamente
      final steamId = await _launchSteamConnectionWithWebView(
        context,
        authUrl,
        nonce,
      );

      if (steamId == null) {
        throw const AuthenticationException(
          message: 'Autenticação Steam cancelada ou falhou',
        );
      }

      // Buscar dados do usuário Steam e criar resultado
      return await completeSteamConnectionWithSteamId(steamId);
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

  Future<String?> _launchSteamConnectionWithWebView(
    BuildContext context,
    String authUrl,
    String nonce,
  ) async {
    try {
      final result = await Navigator.of(context).push<String?>(
        MaterialPageRoute(
          builder: (context) => _SteamAuthWebView(
            authUrl: authUrl,
            onSteamIdReceived: (steamId) {
              Navigator.of(context).pop(steamId);
            },
            onError: (error) {
              Navigator.of(context).pop(null);
            },
          ),
        ),
      );

      return result;
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

/// Widget WebView para autenticação Steam
class _SteamAuthWebView extends StatefulWidget {
  final String authUrl;
  final Function(String steamId) onSteamIdReceived;
  final Function(String error) onError;

  const _SteamAuthWebView({
    required this.authUrl,
    required this.onSteamIdReceived,
    required this.onError,
  });

  @override
  State<_SteamAuthWebView> createState() => _SteamAuthWebViewState();
}

class _SteamAuthWebViewState extends State<_SteamAuthWebView> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steam Login'),
        backgroundColor: const Color(0xFF171a21), // Steam dark blue
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.authUrl)),
            onLoadStart: (controller, url) {
              setState(() => _isLoading = true);
              _checkForCallback(url);
            },
            onLoadStop: (controller, url) {
              setState(() => _isLoading = false);
              _checkForCallback(url);
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              _checkForCallback(url);
            },
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              javaScriptEnabled: true,
              javaScriptCanOpenWindowsAutomatically: false,
              userAgent: 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36',
            ),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url;
              if (_checkForCallback(url)) {
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF66c0f4),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Carregando Steam...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _checkForCallback(WebUri? url) {
    if (url == null) return false;

    final urlString = url.toString();

    // Verificar se é o callback da Steam (via redirect web)
    if (urlString.contains('app.ghub.digital/integrations/steam-callback') ||
        urlString.contains('steam-callback')) {
      try {
        final uri = Uri.parse(urlString);
        final steamId = _extractSteamId(uri.queryParameters);

        if (steamId != null) {
          widget.onSteamIdReceived(steamId);
          return true;
        } else {
          widget.onError('Steam ID não encontrado no callback');
          return true;
        }
      } catch (e) {
        widget.onError('Erro ao processar callback: $e');
        return true;
      }
    }

    return false;
  }

  String? _extractSteamId(Map<String, String> queryParameters) {
    // Steam retorna o identity na forma:
    // https://steamcommunity.com/openid/id/[STEAM_ID]
    final identity = queryParameters['openid.identity'];
    if (identity != null) {
      final steamIdMatch = RegExp(r'\/id\/(\d+)$').firstMatch(identity);
      if (steamIdMatch != null) {
        return steamIdMatch.group(1);
      }
    }

    // Fallback: verificar se Steam ID foi passado diretamente
    return queryParameters['steamId'];
  }
}
