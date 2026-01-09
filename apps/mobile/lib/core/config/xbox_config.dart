import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuração Xbox Live / Microsoft Gaming Services
class XboxConfig {
  // IMPORTANTE: Substitua por suas credenciais reais do Azure AD
  // Para obter essas credenciais:
  // 1. Acesse https://portal.azure.com
  // 2. Registre um aplicativo no Azure AD
  // 3. Configure permissões para Xbox Live
  // 4. Configure redirect URI: ghub://xbox-callback

  static String get clientId =>
      dotenv.env['XBOX_CLIENT_ID'] ??
      'SEU_XBOX_CLIENT_ID_AQUI'; // Application (client) ID
  static String get clientSecret =>
      dotenv.env['XBOX_CLIENT_SECRET'] ??
      'SEU_XBOX_CLIENT_SECRET_AQUI'; // Client secret value
  static String get redirectUri =>
      '${dotenv.env['APP_WEB_URL'] ?? ''}/integrations/xbox-callback';

  // Xbox Live API URLs
  static String get authUrl =>
      dotenv.env['XBOX_AUTH_URL'] ??
      'https://login.live.com/oauth20_authorize.srf';
  static String get tokenUrl =>
      dotenv.env['XBOX_TOKEN_URL'] ??
      'https://login.live.com/oauth20_token.srf';
  static String get xboxLiveUrl =>
      dotenv.env['XBOX_LIVE_URL'] ??
      'https://user.auth.xboxlive.com/user/authenticate';
  static String get xstsUrl =>
      dotenv.env['XBOX_XSTS_URL'] ??
      'https://xsts.auth.xboxlive.com/xsts/authorize';
  static String get profileUrl =>
      dotenv.env['XBOX_PROFILE_URL'] ??
      'https://profile.xboxlive.com/users/me/profile/settings';

  // Scopes necessários para Xbox Live
  static String get scopes =>
      dotenv.env['XBOX_SCOPES'] ?? 'XboxLive.signin XboxLive.offline_access';

  /// Verifica se as credenciais do Xbox estão configuradas
  static bool get isConfigured {
    return clientId != 'SEU_XBOX_CLIENT_ID_AQUI' &&
        clientSecret != 'SEU_XBOX_CLIENT_SECRET_AQUI' &&
        clientId.isNotEmpty &&
        clientSecret.isNotEmpty;
  }

  /// Mensagem de erro quando as credenciais não estão configuradas
  static const String configurationError = '''
Xbox Live não configurado!

Para usar a integração Xbox Live:
1. Acesse https://portal.azure.com
2. Registre um novo aplicativo no Azure Active Directory
3. Configure as permissões necessárias para Xbox Live
4. Adicione o redirect URI: ghub://xbox-callback
5. Copie o Application ID e Client Secret
6. Configure no arquivo .env:
   - XBOX_CLIENT_ID=Application (client) ID
   - XBOX_CLIENT_SECRET=Client secret value
''';
}
