# Xbox Live Integration Setup

Esta integração permite conectar contas Xbox Live ao GHub para sincronizar jogos, conquistas e perfil de usuário.

## Pré-requisitos

1. **Conta Microsoft Developer**: É necessário ter uma conta Microsoft Developer para registrar aplicações no Azure Active Directory.

2. **Azure Active Directory**: O Xbox Live usa o Azure AD para autenticação OAuth2.

## Configuração Passo a Passo

### 1. Registrar Aplicação no Azure Portal

1. Acesse [https://portal.azure.com](https://portal.azure.com)
2. Navegue para **Azure Active Directory** > **App registrations**
3. Clique em **New registration**
4. Preencha as informações:
   - **Name**: GHub Xbox Integration
   - **Supported account types**: Accounts in any organizational directory (Any Azure AD directory - Multitenant) and personal Microsoft accounts
   - **Redirect URI**: 
     - Type: **Public client/native (mobile & desktop)**
     - URI: `ghub://xbox-callback`

### 2. Configurar Credenciais

1. Após criar a aplicação, vá para **Overview** e copie o **Application (client) ID**
2. Vá para **Certificates & secrets**
3. Clique em **New client secret**
4. Adicione uma descrição e escolha uma expiração
5. Copie o **Value** do client secret criado

### 3. Configurar Permissões

1. Vá para **API permissions**
2. Clique em **Add a permission**
3. Selecione **Microsoft Graph**
4. Selecione **Delegated permissions**
5. Adicione as seguintes permissões:
   - `XboxLive.signin`
   - `XboxLive.offline_access`
   - `User.Read`

### 4. Configurar o Aplicativo Flutter

1. Abra o arquivo `lib/core/config/xbox_config.dart`
2. Substitua as constantes:

```dart
class XboxConfig {
  static const String clientId = 'SEU_APPLICATION_CLIENT_ID_AQUI';
  static const String clientSecret = 'SEU_CLIENT_SECRET_VALUE_AQUI';
  // ... resto da configuração
}
```

### 5. Deep Link Configuration

O deep link já está configurado no projeto:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<activity>
    <!-- Configuração existente -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="ghub" />
    </intent-filter>
</activity>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>ghub</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>ghub</string>
        </array>
    </dict>
</array>
```

## Fluxo de Autenticação

1. **Usuário clica em "Connect" no Xbox**: Inicia o fluxo OAuth2
2. **Redirecionamento para Microsoft Login**: Abre browser in-app
3. **Usuário faz login**: Microsoft autentica o usuário
4. **Callback recebido**: App recebe código de autorização via deep link
5. **Troca do código por tokens**: App troca código por access token e XSTS token
6. **Busca perfil do usuário**: Obtém dados do Xbox Live (gamertag, gamerscore, etc.)
7. **Cache local**: Salva dados no cache local do dispositivo
8. **Sincronização de jogos**: Busca e salva jogos do usuário

## Arquivos Modificados/Criados

- `lib/core/config/xbox_config.dart` - Configurações Xbox Live
- `lib/features/integrations/data/services/xbox_live_service.dart` - Serviço Xbox Live
- `lib/features/integrations/presentation/pages/xbox_callback_page.dart` - Página de callback
- `lib/core/services/integrations_cache_service.dart` - Cache das integrações
- `lib/core/router/app_router.dart` - Rota do callback Xbox

## Testando a Integração

1. **Compilar e executar o app**
2. **Navegar para Integrações**
3. **Clicar em "Connect" no Xbox**
4. **Verificar se o browser abre**
5. **Fazer login com conta Microsoft**
6. **Verificar se retorna para o app**
7. **Confirmar que Xbox mostra como conectado**

## Problemas Comuns

### "Xbox Live não configurado"
- Verifique se `clientId` e `clientSecret` foram substituídos corretamente
- Confirme se as credenciais são válidas no Azure Portal

### "Não foi possível abrir o navegador"
- Verifique se o `url_launcher` está funcionando no dispositivo
- Teste em dispositivo físico se necessário

### "Erro na autenticação Xbox"
- Verifique se o redirect URI está configurado corretamente no Azure Portal
- Confirme se as permissões foram concedidas à aplicação

### "Dados não aparecem no cache"
- Verifique logs para erros na Xbox Live API
- Confirme se o usuário tem jogos Xbox e perfil público

## Segurança

- **Client Secret**: Nunca faça commit do client secret real
- **Tokens**: Tokens são armazenados com `FlutterSecureStorage`
- **Cache**: Dados do usuário são cacheados localmente com criptografia
- **HTTPS**: Todas as comunicações são via HTTPS

## Desenvolvimento

Para desenvolvimento, use credenciais de teste e contas Xbox de desenvolvimento conforme diretrizes da Microsoft.

## Suporte

Para questões sobre Xbox Live API, consulte:
- [Xbox Live Developer Documentation](https://docs.microsoft.com/en-us/gaming/xbox-live/)
- [Microsoft Graph API Documentation](https://docs.microsoft.com/en-us/graph/)
- [Azure Active Directory Documentation](https://docs.microsoft.com/en-us/azure/active-directory/)