/// Configuração Xbox Live / Microsoft Gaming Services
class XboxConfig {
  // IMPORTANTE: Substitua por suas credenciais reais do Azure AD
  // Para obter essas credenciais:
  // 1. Acesse https://portal.azure.com
  // 2. Registre um aplicativo no Azure AD
  // 3. Configure permissões para Xbox Live
  // 4. Configure redirect URI: ghub://xbox-callback

  static const String clientId =
      'f5bf5849-794a-4f01-a64a-ad90470397e6'; // Application (client) ID
  static const String clientSecret =
      'a24bde39-c44f-4e08-9140-f94430458412'; // Client secret value
  static const String redirectUri = 'ghub://onboarding/callback/xbox';

  // Xbox Live API URLs
  static const String authUrl = 'https://login.live.com/oauth20_authorize.srf';
  static const String tokenUrl = 'https://login.live.com/oauth20_token.srf';
  static const String xboxLiveUrl =
      'https://user.auth.xboxlive.com/user/authenticate';
  static const String xstsUrl = 'https://xsts.auth.xboxlive.com/xsts/authorize';
  static const String profileUrl =
      'https://profile.xboxlive.com/users/me/profile/settings';

  // Scopes necessários para Xbox Live
  static const String scopes = 'XboxLive.signin XboxLive.offline_access';

  /// Verifica se as credenciais do Xbox estão configuradas
  static bool get isConfigured {
    return clientId != 'SEU_XBOX_CLIENT_ID_AQUI' &&
        clientSecret != 'SEU_XBOX_CLIENT_SECRET_AQUI';
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
6. Substitua as constantes em XboxConfig:
   - clientId: Application (client) ID
   - clientSecret: Client secret value
''';
}
