/// Configuração Xbox Live / Microsoft Gaming Services
class XboxConfig {
  // IMPORTANTE: Substitua por suas credenciais reais do Azure AD
  // Para obter essas credenciais:
  // 1. Acesse https://portal.azure.com
  // 2. Registre um aplicativo no Azure AD
  // 3. Configure permissões para Xbox Live
  // 4. Configure redirect URI: ghub://xbox-callback

  static const String clientId = String.fromEnvironment(
    'XBOX_CLIENT_ID',
    defaultValue: 'SEU_XBOX_CLIENT_ID_AQUI',
  ); // Application (client) ID
  static const String clientSecret = String.fromEnvironment(
    'XBOX_CLIENT_SECRET',
    defaultValue: 'SEU_XBOX_CLIENT_SECRET_AQUI',
  ); // Client secret value
  static const String redirectUri = String.fromEnvironment(
    'XBOX_REDIRECT_URI',
    defaultValue: 'ghub://xbox-callback',
  );

  // Xbox Live API URLs
  static const String authUrl = String.fromEnvironment(
    'XBOX_AUTH_URL',
    defaultValue: 'https://login.live.com/oauth20_authorize.srf',
  );
  static const String tokenUrl = String.fromEnvironment(
    'XBOX_TOKEN_URL',
    defaultValue: 'https://login.live.com/oauth20_token.srf',
  );
  static const String xboxLiveUrl = String.fromEnvironment(
    'XBOX_LIVE_URL',
    defaultValue: 'https://user.auth.xboxlive.com/user/authenticate',
  );
  static const String xstsUrl = String.fromEnvironment(
    'XBOX_XSTS_URL',
    defaultValue: 'https://xsts.auth.xboxlive.com/xsts/authorize',
  );
  static const String profileUrl = String.fromEnvironment(
    'XBOX_PROFILE_URL',
    defaultValue: 'https://profile.xboxlive.com/users/me/profile/settings',
  );

  // Scopes necessários para Xbox Live
  static const String scopes = String.fromEnvironment(
    'XBOX_SCOPES',
    defaultValue: 'XboxLive.signin XboxLive.offline_access',
  );

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
