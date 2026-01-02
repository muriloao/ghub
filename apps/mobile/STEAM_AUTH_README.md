# Login Steam - Integração Direta

Esta implementação permite autenticação direta com a Steam API no Flutter, sem necessidade de backend intermediário.

## Configuração

### 1. Obter Steam API Key

1. Acesse [Steam Web API Registration](https://steamcommunity.com/dev/apikey)
2. Faça login com sua conta Steam
3. Registre um novo domínio (pode usar qualquer domínio válido para desenvolvimento)
4. Copie a API key gerada

### 2. Configurar API Key

Edite o arquivo `lib/core/config/steam_config.dart` e substitua `'SEU_STEAM_API_KEY_AQUI'` pela sua Steam API key:

```dart
class SteamConfig {
  static const String apiKey = 'SUA_STEAM_API_KEY_AQUI'; // Substitua aqui
  // ...
}
```

**IMPORTANTE**: Para produção, mova a API key para variáveis de ambiente ou configuração segura.

### 3. Dependências

As seguintes dependências já estão configuradas no `pubspec.yaml`:

- `webview_flutter: ^4.8.0` - Para WebView de autenticação
- `crypto: ^3.0.5` - Para operações criptográficas
- `dio` - Cliente HTTP para comunicação com Steam API

## Como Funciona

### Fluxo de Autenticação

1. **Usuário clica no botão "Login com Steam"**
2. **WebView abre** com a página de login da Steam
3. **Usuário faz login** na Steam através da WebView
4. **Steam redireciona** para URL de callback personalizada
5. **App captura** o Steam ID do callback
6. **Busca dados** do usuário na Steam Web API
7. **Cria tokens** de acesso e refresh
8. **Retorna resultado** da autenticação

### Arquivos Principais

#### Serviço de Autenticação
- `lib/features/auth/data/services/steam_auth_service.dart`
  - Gerencia todo o fluxo de autenticação Steam
  - Abre WebView para login
  - Captura callback e extrai Steam ID
  - Busca dados do usuário na Steam API

#### Modelos de Dados
- `lib/features/auth/data/models/steam_user_model.dart`
  - Modelos para resposta da Steam API
  - Gerado automaticamente com `json_serializable`

#### Configuração
- `lib/core/config/steam_config.dart`
  - Constantes de configuração da Steam API
  - URLs e parâmetros do OpenID

#### Interface
- `lib/features/auth/presentation/widgets/social_login_buttons.dart`
  - Botão de login Steam na UI

## Uso

### No Widget de Login

O botão de Steam já está integrado no componente `SocialLoginButtons`:

```dart
SocialLoginButtons(
  onSteamPressed: () async {
    await ref.read(authNotifierProvider.notifier).loginWithSteam(context);
  },
)
```

### Programaticamente

Para autenticar via Steam diretamente:

```dart
final authNotifier = ref.read(authNotifierProvider.notifier);
final result = await authNotifier.loginWithSteam(context);

if (result != null) {
  // Login realizado com sucesso
  final user = result.user;
  print('Usuário logado: ${user.name}');
} else {
  // Login cancelado ou falhou
  print('Login falhou');
}
```

## Estrutura de Dados

### Steam User Response
```json
{
  "response": {
    "players": [
      {
        "steamid": "76561198000000000",
        "communityvisibilitystate": 3,
        "profilestate": 1,
        "personaname": "Nome do Jogador",
        "profileurl": "https://steamcommunity.com/id/jogador/",
        "avatar": "https://avatars.akamai.steamstatic.com/avatar_small.jpg",
        "avatarmedium": "https://avatars.akamai.steamstatic.com/avatar_medium.jpg",
        "avatarfull": "https://avatars.akamai.steamstatic.com/avatar_full.jpg",
        "personastate": 1,
        "timecreated": 1234567890
      }
    ]
  }
}
```

### Auth Result
O serviço retorna um `AuthResultModel` com:
- `accessToken`: Token de acesso gerado
- `refreshToken`: Token de refresh gerado  
- `user`: Dados do usuário convertidos para formato interno

## Desenvolvimento e Debug

### Executar build_runner para gerar modelos
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Verificar análise de código
```bash
flutter analyze lib/features/auth/
```

### Logs de Debug
Os logs podem ser visualizados no console durante o desenvolvimento. O serviço inclui logs detalhados do fluxo de autenticação.

## Produção

### Segurança
1. **API Key**: Mova para variável de ambiente
2. **Tokens**: Implemente JWT real com assinatura
3. **Validação**: Adicione validação de callback do Steam
4. **Rate Limiting**: Considere limits de requests

### Deep Linking
Para produção, configure deep linking apropriado:
1. Configure `ghub://` scheme no Android (`android/app/src/main/AndroidManifest.xml`)
2. Configure custom URL scheme no iOS (`ios/Runner/Info.plist`)

### Monitoramento
Adicione logging e analytics para monitorar:
- Taxa de sucesso de login
- Tempo de autenticação
- Erros de API

## Troubleshooting

### Erro: "Steam API Key não configurada"
- Verifique se substituiu `'SEU_STEAM_API_KEY_AQUI'` pela key real

### Erro: "Usuário Steam não encontrado"
- Verifique se a API key é válida
- Confirme conectividade com internet
- Verifique se o Steam ID foi extraído corretamente

### WebView não abre
- Verifique permissões de internet
- Confirme que `webview_flutter` está configurado corretamente

### Callback não funciona
- Verifique se a URL de callback está configurada corretamente
- Confirme que o deep linking está funcionando