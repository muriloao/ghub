# Deep Linking Implementation

Este documento explica como o deep linking foi implementado no app GameCentral usando o custom scheme `ghub`.

## Configuração

### 1. Custom Scheme 'ghub'

O app foi configurado para escutar URLs com o scheme personalizado `ghub://`.

#### Android
- Configurado em `android/app/src/main/AndroidManifest.xml`
- Intent filter para capturar URLs `ghub://`

#### iOS
- Configurado em `ios/Runner/Info.plist`
- CFBundleURLTypes definido para o scheme `ghub`

### 2. Biblioteca app_links

Adicionada ao `pubspec.yaml`:
```yaml
app_links: ^6.4.0
```

## Arquitetura

### DeepLinkService
- **Localização**: `lib/core/services/deep_link_service.dart`
- **Função**: Gerencia deep links do app
- **Features**:
  - Escuta URLs do formato `ghub://onboarding/callback`
  - Redireciona para rotas internas correspondentes
  - Extração de parâmetros (incluindo Steam ID)

### Provider
- **Localização**: `lib/core/providers/deep_link_provider.dart`
- **Função**: Provider Riverpod para o DeepLinkService

### Rota de Callback
- **Rota interna**: `/onboarding/callback`
- **Página**: `SteamCallbackPage`
- **Função**: Processa callback da autenticação Steam

## Fluxo de Autenticação Steam

1. **Usuário inicia login Steam**
   - `SteamAuthService.authenticateWithSteam()` é chamado
   - URL de autenticação Steam é construída com `returnUrl = 'ghub://onboarding/callback'`

2. **Browser abre Steam**
   - `url_launcher` com `LaunchMode.inAppBrowserView`
   - Usuário faz login na Steam

3. **Steam redireciona**
   - Steam redireciona para `ghub://onboarding/callback?[params]`
   - DeepLinkService captura o deep link

4. **Processamento interno**
   - URL é convertida para rota interna `/onboarding/callback`
   - GoRouter navega para `SteamCallbackPage`
   - Steam ID é extraído dos parâmetros
   - Autenticação é finalizada

## Uso

### Testando Deep Links

#### Via ADB (Android)
```bash
adb shell am start \\
  -W -a android.intent.action.VIEW \\
  -d "ghub://onboarding/callback?openid.identity=https://steamcommunity.com/openid/id/76561198123456789" \\
  com.gamecentral.mobile
```

#### Via Simulador iOS
```bash
xcrun simctl openurl booted "ghub://onboarding/callback?openid.identity=https://steamcommunity.com/openid/id/76561198123456789"
```

### Estrutura de URLs

- **Scheme**: `ghub://`
- **Host**: Qualquer (ex: `auth`)
- **Path**: Caminho da rota (ex: `/steam/callback`)
- **Parâmetros**: Query parameters passados para a rota interna

### Exemplos

| Deep Link                            | Rota Interna                   |
| ------------------------------------ | ------------------------------ |
| `ghub://onboarding/callback`         | `/onboarding/callback`         |
| `ghub://games/library?filter=recent` | `/games/library?filter=recent` |
| `ghub://profile/settings`            | `/profile/settings`            |

## Configurações Adicionais

### main.dart
- DeepLinkService é inicializado no `MyApp.build()`
- Integração com GoRouter para navegação

### SteamAuthService
- Removido input manual de Steam ID
- Agora usa deep linking para capturar callback automático
- Retorna `null` após abrir browser, esperando processamento via deep link

## Melhorias Futuras

1. **Deep Linking Reverso**: Implementar links que abrem o app a partir de websites
2. **Validação de Parâmetros**: Validar assinatura OpenID do Steam
3. **Timeout Handling**: Lidar com casos onde usuário não retorna da Steam
4. **Universal Links**: Implementar Universal Links (iOS) / App Links (Android)