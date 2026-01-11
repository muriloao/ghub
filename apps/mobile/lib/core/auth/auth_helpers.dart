import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Helper para implementar PKCE (Proof Key for Code Exchange) em OAuth2
/// Usado para Epic Games e Xbox para segurança sem client secret
class PKCEHelper {
  /// Gera um code verifier aleatório para PKCE
  static String generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Gera um code challenge baseado no code verifier usando SHA256
  static String generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// Gera um state parameter seguro para prevenir CSRF
  static String generateSecureState() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Gera um nonce seguro para OpenID (Steam)
  static String generateSecureNonce() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }
}

/// Helper para validação de callbacks de autenticação
class AuthCallbackValidator {
  /// Valida se o callback é de origem confiável
  static bool validateCallback(
    Uri uri,
    String expectedScheme,
    String? expectedState,
  ) {
    // Validar scheme
    if (uri.scheme != expectedScheme) {
      return false;
    }

    // Validar state se fornecido (previne CSRF)
    if (expectedState != null) {
      final receivedState = uri.queryParameters['state'];
      if (receivedState != expectedState) {
        return false;
      }
    }

    return true;
  }

  /// Extrai parâmetros do callback baseado na plataforma
  static Map<String, String> extractCallbackParams(Uri uri, String platform) {
    final params = <String, String>{};

    switch (platform.toLowerCase()) {
      case 'steam':
        // Steam usa OpenID - extrair steamId do identity
        final identity = uri.queryParameters['openid.identity'];
        if (identity != null) {
          final steamIdMatch = RegExp(r'\/id\/(\d+)$').firstMatch(identity);
          if (steamIdMatch != null) {
            params['steamId'] = steamIdMatch.group(1)!;
          }
        }
        break;

      case 'epic':
      case 'xbox':
        // OAuth2 standard - extrair code e state
        if (uri.queryParameters['code'] != null) {
          params['code'] = uri.queryParameters['code']!;
        }
        if (uri.queryParameters['state'] != null) {
          params['state'] = uri.queryParameters['state']!;
        }
        break;
    }

    // Adicionar todos os query parameters para flexibilidade
    params.addAll(uri.queryParameters);

    return params;
  }
}
