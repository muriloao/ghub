import '../../../features/auth/data/models/auth_result_model.dart';

/// Serviço base abstrato para autenticação de plataformas
abstract class PlatformAuthService {
  /// Nome da plataforma (Steam, Epic, Xbox, etc.)
  String get platformName;

  /// Ícone da plataforma
  String get platformIcon;

  /// Cor primária da plataforma
  int get platformColor;

  /// Autentica o usuário com a plataforma
  Future<AuthResultModel?> authenticate();

  /// Desconecta o usuário da plataforma
  Future<void> disconnect();

  /// Atualiza o token de acesso
  Future<bool> refreshToken();

  /// Verifica se o usuário está autenticado
  Future<bool> isAuthenticated();

  /// Valida se as configurações necessárias estão presentes
  bool validateConfiguration();
}

/// Estados possíveis de autenticação de plataforma
enum PlatformAuthState {
  notAuthenticated,
  authenticating,
  authenticated,
  error,
}

/// Resultado de callback de autenticação
class AuthCallbackResult {
  final bool success;
  final String? steamId;
  final String? authCode;
  final String? accessToken;
  final String? refreshToken;
  final String? error;
  final Map<String, String>? additionalParams;

  const AuthCallbackResult({
    required this.success,
    this.steamId,
    this.authCode,
    this.accessToken,
    this.refreshToken,
    this.error,
    this.additionalParams,
  });

  factory AuthCallbackResult.success({
    String? steamId,
    String? authCode,
    String? accessToken,
    String? refreshToken,
    Map<String, String>? additionalParams,
  }) {
    return AuthCallbackResult(
      success: true,
      steamId: steamId,
      authCode: authCode,
      accessToken: accessToken,
      refreshToken: refreshToken,
      additionalParams: additionalParams,
    );
  }

  factory AuthCallbackResult.error(String error) {
    return AuthCallbackResult(success: false, error: error);
  }

  /// Converte para Map para armazenamento seguro
  Map<String, dynamic> toSecureStorageMap() {
    return {
      'success': success,
      if (steamId != null) 'steamId': steamId,
      if (authCode != null) 'authCode': authCode,
      if (accessToken != null) 'accessToken': accessToken,
      if (refreshToken != null) 'refreshToken': refreshToken,
      if (error != null) 'error': error,
      if (additionalParams != null) 'additionalParams': additionalParams,
    };
  }
}
