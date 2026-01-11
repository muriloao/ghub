# STEAM_CONNECTION_PROVIDER.md

## Steam OpenID 2.0 - Sistema de Conexão

Esta documentação descreve como utilizar o sistema de conexão Steam implementado usando OpenID 2.0 via external browser.

### Arquitetura

O sistema utiliza:
- **Backend NestJS**: Gerencia sessões e autenticação OpenID 2.0
- **External Browser**: Evita problemas com WebView e deep links
- **Polling**: Verifica status da conexão de forma assíncrona
- **Riverpod**: State management reativo no Flutter

### Componentes Principais

#### 1. SteamConnectionProvider (`steam_connection_provider.dart`)
Provider principal que gerencia o estado da conexão Steam.

```dart
// Usar o provider
final steamState = ref.watch(steamConnectionProvider);
final steamNotifier = ref.read(steamConnectionProvider.notifier);

// Conectar
await steamNotifier.connectSteam();

// Desconectar
await steamNotifier.disconnect();

// Retry após erro
await steamNotifier.retry();
```

#### 2. Estados Disponíveis

```dart
enum SteamConnectionStatus {
  idle,        // Não conectado
  connecting,  // Abrindo browser
  polling,     // Aguardando confirmação
  success,     // Conectado com sucesso
  error        // Erro na conexão
}
```

#### 3. SteamConnectionWidget (`steam_connection_widget.dart`)
Widget completo com UI responsiva para todos os estados.

```dart
// Usar em qualquer tela
SteamConnectionWidget()
```

### Fluxo de Funcionamento

1. **Início da Conexão**: Usuário clica em "Conectar"
2. **Session Creation**: Backend cria sessão única
3. **External Browser**: Abre Steam OpenID no browser
4. **User Authentication**: Usuário faz login na Steam
5. **Callback Processing**: Backend valida resposta OpenID
6. **Polling Loop**: App verifica status a cada 2 segundos
7. **Success/Error**: Estado final atualizado

### Endpoints Backend (NestJS)

#### GET `/api/auth/steam/start`
- Cria nova sessão
- Redireciona para Steam OpenID
- Retorna: HTTP 302 + session_id em cookie

#### GET `/api/auth/steam/callback`
- Recebe resposta da Steam
- Valida assinatura OpenID 2.0
- Busca dados do usuário
- Salva na sessão
- Redireciona para página de sucesso

#### GET `/api/auth/steam/status/{session_id}`
- Verifica status da sessão
- Retorna dados do usuário se conectado
- TTL de 10 minutos por sessão

### Frontend (Flutter)

#### Provider Setup

```dart
// No main.dart ou setup inicial
final steamState = ref.watch(steamConnectionProvider);
```

#### Integração em Telas

```dart
// Em uma página de configurações
class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          SteamConnectionWidget(), // Widget completo
          // outros widgets...
        ],
      ),
    );
  }
}
```

#### Status Checking

```dart
// Verificar status atual
final steamState = ref.watch(steamConnectionProvider);

if (steamState.status == SteamConnectionStatus.success) {
  // Usuário conectado
  final steamId = steamState.steamId;
  final userData = steamState.userData;
}
```

### Configurações

#### Backend Environment Variables
```bash
# .env
STEAM_API_KEY=your_steam_api_key
APP_BASE_URL=https://yourapp.com
```

#### Frontend Constants
```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String baseApiUrl = 'https://your-api.com';
  static const Duration pollingInterval = Duration(seconds: 2);
  static const Duration connectionTimeout = Duration(minutes: 10);
}
```

### Tratamento de Erros

#### Erros Comuns

1. **Session Expired**: Sessão expirou (10min TTL)
2. **Network Error**: Problemas de conectividade
3. **Steam API Error**: API indisponível
4. **Timeout**: Usuário não completou login
5. **Cancelled**: Usuário cancelou no browser

#### Handling

```dart
// Listener para erros
ref.listen(steamConnectionProvider, (previous, next) {
  if (next.status == SteamConnectionStatus.error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error ?? 'Erro desconhecido')),
    );
  }
});
```

### Segurança

- ✅ OpenID 2.0 signature validation
- ✅ Session-based com TTL
- ✅ External browser (sem WebView vulnerabilities)
- ✅ HTTPS obrigatório
- ✅ Rate limiting nos endpoints
- ✅ Sanitização de dados de entrada

### Performance

- **Polling Interval**: 2 segundos (configurável)
- **Session TTL**: 10 minutos
- **Timeout**: 10 minutos máximo
- **Auto-cleanup**: Sessions antigas removidas automaticamente

### Debugging

#### Flutter Debug
```dart
// Ativar logs
import 'dart:developer' as dev;

// No provider
dev.log('Steam connection started: $sessionId');
```

#### Backend Debug
```bash
# NestJS logs
npm run start:dev
# Verificar logs dos endpoints Steam
```

### Testando

```dart
// Testing com Riverpod
testWidgets('Steam connection flow', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        steamConnectionProvider.overrideWith(
          () => SteamConnectionNotifier(mockApiService),
        ),
      ],
      child: MyApp(),
    ),
  );
  
  // Test interactions...
});
```

### Migração de WebView

Se você tinha WebView antes:

1. **Remove**: Configurações de deep links Steam
2. **Remove**: WebView dependencies
3. **Add**: `url_launcher` dependency
4. **Replace**: Provider calls para novo sistema
5. **Update**: UI components para novos estados

### Troubleshooting

**Problema**: Polling não para
```dart
// Verificar se dispose está sendo chamado
@override
void dispose() {
  _pollingTimer?.cancel();
  super.dispose();
}
```

**Problema**: Session não encontrada
- Verificar se backend está rodando
- Verificar environment variables
- Verificar TTL das sessões

**Problema**: Browser não abre
- Verificar permissões do app
- Verificar url_launcher configuration
- Testar em device físico

### Conclusão

O sistema Steam OpenID 2.0 fornece uma solução robusta e segura para autenticação Steam sem as limitações do WebView. O uso de polling permite uma UX fluida enquanto mantém a segurança da autenticação external browser.