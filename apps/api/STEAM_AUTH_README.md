# Steam Authentication API

Este módulo implementa autenticação via Steam usando OpenID para integração com o app Flutter.

## Configuração

### 1. Variáveis de Ambiente

Crie um arquivo `.env` baseado no `.env.example`:

```bash
cp .env.example .env
```

Configure as seguintes variáveis:

- `STEAM_API_KEY`: Obtenha sua chave em https://steamcommunity.com/dev/apikey
- `APP_URL`: URL base da sua aplicação (ex: http://localhost:3000)
- `PORT`: Porta da aplicação (padrão: 3000)

### 2. Chave da API Steam

1. Acesse https://steamcommunity.com/dev/apikey
2. Faça login com sua conta Steam
3. Digite o domínio da sua aplicação (ex: localhost para desenvolvimento)
4. Copie a chave gerada para a variável `STEAM_API_KEY`

## Endpoints

### POST /onboarding/url

Gera uma URL de autenticação Steam e um sessionId para rastreamento.

**Response:**
```json
{
  "url": "https://steamcommunity.com/openid/login?...",
  "sessionId": "uuid-session-id"
}
```

### GET /onboarding/callback/:sessionId

Verifica o status da autenticação para um sessionId específico.

**Response (Pendente):**
```json
{
  "authenticated": false,
  "message": "Aguardando autenticação Steam"
}
```

**Response (Sucesso):**
```json
{
  "authenticated": true,
  "accessToken": "...",
  "refreshToken": "...",
  "user": {
    "id": "steam_76561198000000000",
    "email": "76561198000000000@steam.local",
    "name": "Steam Username",
    "avatarUrl": "https://avatars.steamstatic.com/...",
    "createdAt": "2025-01-01T00:00:00.000Z",
    "updatedAt": "2025-01-01T00:00:00.000Z"
  }
}
```

### GET /onboarding/return/:sessionId (Interno)

Endpoint interno usado pelo Steam para retorno após autenticação.
Não deve ser chamado diretamente pelo app.

## Fluxo de Autenticação

1. **App chama** `POST /onboarding/url`
2. **API retorna** URL Steam e sessionId
3. **App abre** navegador com URL Steam
4. **Usuário autentica** no Steam
5. **Steam redireciona** para `/onboarding/return/:sessionId`
6. **API processa** resposta e marca sessão como autenticada
7. **App faz polling** em `/onboarding/callback/:sessionId` até receber sucesso
8. **API retorna** tokens e dados do usuário

## Desenvolvimento

### Instalar dependências
```bash
npm install
```

### Rodar em desenvolvimento
```bash
npm run start:dev
```

### Rodar testes
```bash
npm test
```

### Build para produção
```bash
npm run build
npm run start:prod
```

## Notas Importantes

- As sessões Steam expiram em 10 minutos
- O sistema faz limpeza automática de sessões expiradas
- O email Steam é gerado artificialmente (steamid@steam.local) pois Steam não fornece email
- Tokens JWT são mockados - implementar geração real conforme necessário
- Integração com banco de dados está pendente - dados são mockados

## Integração com Flutter

O app Flutter já está configurado para usar estes endpoints:
- `POST /onboarding/url` para obter URL de login
- `GET /onboarding/callback/:sessionId` para verificar status (polling a cada 5 segundos)

## TODO

- [ ] Implementar JWT real para tokens
- [ ] Integração com banco de dados
- [ ] Sistema de refresh tokens
- [ ] Rate limiting nos endpoints
- [ ] Logs estruturados
- [ ] Testes unitários e de integração