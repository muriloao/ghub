import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Serviço responsável por gerenciar deep links do app
///
/// Escuta URLs do formato 'ghub://onboarding/callback' e
/// redireciona para rotas internas correspondentes
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  GoRouter? _router;

  /// Inicializa o serviço de deep linking
  ///
  /// [router] - Instância do GoRouter para navegação
  Future<void> initialize(GoRouter router) async {
    _router = router;

    // Verificar se o app foi aberto por um deep link PRIMEIRO
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        if (kDebugMode) {
          print('Deep link inicial encontrado: $initialUri');
        }
        await _handleIncomingLink(initialUri);
      }
    } catch (e) {
      if (kDebugMode) {
        print('DeepLink Initial Link Error: $e');
      }
    }

    // Depois configurar listener para deep links futuros
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleIncomingLink,
      onError: (err) {
        if (kDebugMode) {
          print('DeepLink Error: $err');
        }
      },
    );
  }

  /// Processa deep link recebido e redireciona para rota interna
  Future<void> _handleIncomingLink(Uri uri) async {
    if (kDebugMode) {
      print('Deep Link recebido: $uri');
    }

    // Validar scheme
    if (uri.scheme != 'ghub') {
      if (kDebugMode) {
        print('Scheme inválido: ${uri.scheme}');
      }
      return;
    }

    // Construir rota interna removendo o scheme
    // Ex: ghub://onboarding/callback -> /onboarding/callback
    final fullRoute = _buildInternalRoute(_router, uri);

    if (kDebugMode) {
      print('Redirecionando para: $fullRoute');
    }
    if (fullRoute == null) {
      if (kDebugMode) {
        print('Rota interna inválida para URI: $uri');
      }
      return;
    }
    // Navegar para a rota interna usando go() que substitui a rota atual
    // _router!.go(fullRoute, extra: getQueryParameters(uri));
    _router!.go(fullRoute);
  }

  /// Constrói rota interna baseada na URI do deep link
  String? _buildInternalRoute(GoRouter? router, Uri uri) {
    final internalRoute =
        '/${uri.host}${uri.pathSegments.isNotEmpty ? '/${uri.pathSegments.join('/')}' : ''}';

    if (internalRoute.isNotEmpty && router != null) {
      // Construir URL completa com query parameters
      final queryString = uri.queryParameters.isNotEmpty
          ? '?${uri.queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      // return internalRoute;
      return '$internalRoute$queryString';
    }
    return null;
  }

  /// Retorna os query parameters de uma URI
  Map<String, String> getQueryParameters(Uri uri) {
    return uri.queryParameters;
  }

  /// Método utilitário para extrair Steam ID do callback
  String? extractSteamIdFromCallbackQueryParameters(
    Map<String, String> queryParameters,
  ) {
    // Processar parâmetros de retorno do Steam OpenID
    final params = queryParameters;

    // Steam retorna o identity na forma:
    // https://steamcommunity.com/openid/id/[STEAM_ID]
    final identity = params['openid.identity'];
    if (identity != null) {
      final steamIdMatch = RegExp(r'\/id\/(\d+)$').firstMatch(identity);
      if (steamIdMatch != null) {
        return steamIdMatch.group(1);
      }
    }

    // Fallback: verificar se Steam ID foi passado diretamente
    return params['steamId'];
  }

  /// Para o serviço e limpa recursos
  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _router = null;
  }
}
