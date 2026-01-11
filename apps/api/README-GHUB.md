# GHub API

API NestJS para gerenciar integrações de plataformas de jogos (Steam, Epic Games, Xbox).

## 🚀 Quick Start

### 1. Instalação
```bash
npm install
```

### 2. Configuração
Copie o arquivo `.env.example` para `.env` e configure as variáveis:

```bash
cp .env.example .env
```

**Variáveis obrigatórias:**
- `STEAM_API_KEY`: Chave da Steam Web API ([obter aqui](https://steamcommunity.com/dev/apikey))
- `JWT_SECRET`: Chave secreta para JWT tokens

### 3. Execução
```bash
# Desenvolvimento
npm run start:dev

# Produção
npm run build
npm run start:prod
```

A API estará disponível em `http://localhost:3000`  
Documentação Swagger: `http://localhost:3000/docs`

## 📚 Endpoints Steam

### POST /auth/steam/start
Inicia processo de autenticação Steam

**Body:**
```json
{
  "clientId": "ghub-mobile-client",
  "redirectUrl": "http://localhost:3000/auth/steam/callback"
}
```

**Response:**
```json
{
  "authUrl": "https://steamcommunity.com/openid/login?...",
  "nonce": "abc123..."
}
```

### GET /auth/steam/callback
Processa callback do Steam OpenID (chamado automaticamente pelo Steam)

**Query Parameters:** Parâmetros OpenID do Steam

**Response:**
```json
{
  "success": true,
  "user": {
    "id": "steam_76561198000000000",
    "steamId": "76561198000000000",
    "name": "Username",
    "avatar": "https://avatars.cloudflare.steamstatic.com/...",
    "email": "76561198000000000@steam.local"
  },
  "tokens": {
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "expires_in": 3600
  }
}
```

## 🔧 Integração Mobile

### 1. Fluxo de Autenticação

**No app Flutter:**
```dart
// 1. Solicitar URL de autenticação para API
final response = await dio.post('/auth/steam/start', data: {
  'clientId': 'ghub-mobile-client',
});

final authUrl = response.data['authUrl'];
final nonce = response.data['nonce'];

// 2. Abrir navegador externo
await launchUrl(Uri.parse(authUrl), mode: LaunchMode.externalApplication);

// 3. Steam redireciona para: 
// http://localhost:3000/auth/steam/callback?openid.ns=...&openid.mode=...

// 4. API processa callback e retorna resultado
// 5. App pode fazer polling ou usar WebSocket para obter resultado
```

### 2. Obter Resultado da Autenticação

Você pode implementar uma das estratégias:

**A) Polling:**
```dart
// Fazer polling até obter resultado
while (true) {
  final result = await dio.get('/auth/steam/status/$nonce');
  if (result.data['completed']) {
    // Processar tokens
    break;
  }
  await Future.delayed(Duration(seconds: 2));
}
```

**B) WebSocket (recomendado):**
```dart
// Conectar WebSocket e aguardar resultado
final socket = io.connect('ws://localhost:3000');
socket.emit('subscribe', nonce);
socket.on('auth_complete', (data) {
  // Processar resultado
});
```

## 🔐 Segurança

- ✅ **Validação OpenID**: Assinatura Steam é validada
- ✅ **JWT Tokens**: Access/refresh tokens seguros
- ✅ **Session Management**: Sessões temporárias com TTL
- ✅ **CORS**: Configurado para domínios específicos
- ✅ **Validation**: DTOs com class-validator

## 🏗️ Arquitetura

```
src/
├── controllers/         # Endpoints REST
│   └── steam.controller.ts
├── services/           # Business logic
│   ├── steam.service.ts
│   └── session-cleanup.service.ts
├── modules/            # NestJS modules
│   └── steam.module.ts
├── dto/               # Data Transfer Objects
│   └── steam.dto.ts
├── interfaces/        # TypeScript interfaces
│   └── steam.interface.ts
└── main.ts           # Bootstrap da aplicação
```

## 🔄 Próximas Implementações

- [ ] Epic Games OAuth2 + PKCE
- [ ] Xbox Multi-step Authentication  
- [ ] WebSocket para real-time auth status
- [ ] Database integration (PostgreSQL)
- [ ] Redis para session storage
- [ ] Rate limiting
- [ ] Logging structured

## 📝 Logs

```bash
# Visualizar logs em desenvolvimento
npm run start:dev

# Logs incluem:
[SteamService] Steam auth started for client: ghub-mobile-client
[SteamController] Starting Steam auth for client: ghub-mobile-client
[SteamService] Steam auth successful for user: PlayerName (76561198000000000)
```