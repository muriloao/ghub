# Gaming Platforms API

## Endpoints

### GET /platforms
Lista todas as plataformas de jogos cadastradas no sistema.

**Resposta:**
```json
{
  "platforms": [...],
  "totalCount": 4,
  "lastUpdated": "2026-01-11T14:49:26.631Z"
}
```

### GET /platforms/enabled
Lista apenas as plataformas habilitadas para conexão.

**Resposta:**
```json
{
  "platforms": [
    {
      "id": "steam",
      "name": "steam",
      "displayName": "Steam",
      "description": "A maior plataforma de distribuição digital de jogos para PC",
      "logoUrl": "https://store.steampowered.com/public/shared/images/header/logo_steam.svg",
      "colorScheme": {
        "primary": "#1b2838",
        "secondary": "#66c0f4"
      },
      "endpoints": {
        "baseUrl": "https://api.steampowered.com",
        "auth": "https://steamcommunity.com/openid/login",
        "userProfile": "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/",
        "gameLibrary": "https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/",
        "achievements": "https://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/",
        "friendsList": "https://api.steampowered.com/ISteamUser/GetFriendList/v0001/",
        "gameStats": "https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v0002/"
      },
      "authConfig": {
        "type": "openid",
        "clientIdRequired": false,
        "secretRequired": true,
        "redirectUri": "ghub://steam-auth",
        "scopes": []
      },
      "features": {
        "gameLibrary": true,
        "achievements": true,
        "friendsList": true,
        "gameStats": true,
        "screenshots": false,
        "gameTime": true
      },
      "isEnabled": true,
      "comingSoon": false,
      "priority": 1
    }
  ],
  "totalCount": 1,
  "lastUpdated": "2026-01-11T14:49:39.402Z"
}
```

### GET /platforms/available
Lista as plataformas habilitadas ou que estarão disponíveis em breve.

### GET /platforms/:id
Retorna informações específicas de uma plataforma pelo ID.

**Parâmetros:**
- `id`: ID da plataforma (steam, epic, xbox, playstation)

**Resposta:** Objeto da plataforma ou erro 404 se não encontrada.

## Estrutura dos Dados

### GamingPlatformDto
```typescript
{
  id: string;                    // Identificador único
  name: string;                  // Nome técnico
  displayName: string;           // Nome para exibição
  description: string;           // Descrição da plataforma
  logoUrl: string;              // URL do logotipo
  colorScheme: {
    primary: string;             // Cor primária
    secondary: string;           // Cor secundária
  };
  endpoints: {
    baseUrl: string;             // URL base da API
    auth: string;                // Endpoint de autenticação
    userProfile: string;         // Endpoint do perfil do usuário
    gameLibrary: string;         // Endpoint da biblioteca de jogos
    achievements: string;        // Endpoint de conquistas
    friendsList?: string;        // Endpoint da lista de amigos (opcional)
    gameStats?: string;          // Endpoint de estatísticas de jogos (opcional)
  };
  authConfig: {
    type: 'oauth2' | 'openid';   // Tipo de autenticação
    clientIdRequired: boolean;    // Se requer client ID
    secretRequired: boolean;      // Se requer client secret
    redirectUri: string;         // URI de redirecionamento
    scopes: string[];            // Escopos necessários
  };
  features: {
    gameLibrary: boolean;        // Suporte à biblioteca de jogos
    achievements: boolean;       // Suporte a conquistas
    friendsList: boolean;        // Suporte à lista de amigos
    gameStats: boolean;          // Suporte a estatísticas
    screenshots: boolean;        // Suporte a screenshots
    gameTime: boolean;           // Suporte a tempo de jogo
  };
  isEnabled: boolean;            // Se a plataforma está habilitada
  comingSoon: boolean;           // Se a plataforma estará disponível em breve
  priority: number;              // Prioridade para ordenação
}
```

## Plataformas Suportadas

### Habilitadas
- **Steam**: Plataforma completa com biblioteca, conquistas e estatísticas

### Em Breve (Coming Soon)
- **Epic Games**: OAuth2, biblioteca e conquistas
- **Xbox Live**: OAuth2 completo com todas as funcionalidades
- **PlayStation Network**: OAuth2, biblioteca e conquistas

## Uso no App Mobile

O app mobile deve consumir estes endpoints para:

1. **Lista de Plataformas**: `GET /platforms/available` para mostrar plataformas na tela de conexão
2. **Configuração**: Usar os dados dos `endpoints` e `authConfig` para configurar autenticação
3. **Features**: Verificar quais funcionalidades estão disponíveis por plataforma
4. **UI/UX**: Usar `colorScheme` e `logoUrl` para interface consistente
5. **Deep Links**: Configurar `redirectUri` para captura dos callbacks de autenticação

### Exemplo de Integração
```typescript
// Buscar plataformas disponíveis
const response = await fetch('http://localhost:3000/platforms/available');
const { platforms } = await response.json();

// Configurar autenticação baseada nos dados da plataforma
const steamPlatform = platforms.find(p => p.id === 'steam');
const authUrl = `${steamPlatform.endpoints.auth}?...`;
```