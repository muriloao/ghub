# Feature de Integrações

## Visão Geral

Esta feature implementa uma tela de integrações onde os usuários podem conectar suas contas de diferentes lojas de jogos como Epic Games, Xbox Games, Amazon Games, GOG Galaxy, Uplay, EA Play, entre outras.

## Estrutura

A feature segue o padrão de Clean Architecture utilizado no projeto:

```
lib/features/integrations/
├── data/
│   └── models/
│       └── gaming_platform_model.dart          # Modelo de dados das plataformas
├── domain/
│   └── entities/
│       └── gaming_platform.dart                # Entidade de domínio das plataformas
├── presentation/
│   ├── pages/
│   │   └── integrations_page.dart              # Página principal de integrações
│   ├── providers/
│   │   ├── integrations_notifier.dart          # Notifier para gerenciamento de estado
│   │   └── integrations_providers.dart         # Providers do Riverpod
│   └── widgets/
│       ├── platform_card.dart                  # Card individual das plataformas
│       └── integrations_progress_bar.dart      # Barra de progresso das conexões
└── integrations.dart                           # Arquivo barrel para exports
```

## Funcionalidades

### 1. **Visualização das Plataformas**
- Lista de todas as plataformas de jogos disponíveis
- Indicadores visuais de status (conectado/desconectado/conectando)
- Cards personalizados para cada plataforma com cores e ícones únicos

### 2. **Gerenciamento de Conexões**
- Conectar/desconectar plataformas
- Feedback visual durante o processo de conexão
- Estados de loading e erro

### 3. **Progresso das Conexões**
- Barra de progresso mostrando quantas plataformas estão conectadas
- Porcentagem de conexões completadas
- Contadores dinâmicos

### 4. **Design Responsivo**
- Interface adaptável para modo claro e escuro
- Seguindo o design system do app
- Animações e transições suaves

## Plataformas Suportadas

- **Steam** - Jogos, Conquistas, Amigos (já conectada)
- **Xbox** - Jogos, Amigos
- **PlayStation** - Jogos, Troféus  
- **Epic Games** - Apenas Jogos
- **GOG Galaxy** - Jogos, Amigos
- **Uplay** - Jogos, Conquistas
- **EA Play** - Apenas Jogos
- **Amazon Games** - Jogos, Prime Gaming

## Estado Inicial

Por padrão, a feature inicializa com:
- Steam conectada (baseada na autenticação existente)
- Xbox conectada (simulação)
- Outras plataformas desconectadas

## Como Acessar

A tela de integrações pode ser acessada através de:
- Botão de hub/integrações no header da GamesPage
- Rota direta: `/integrations`
- Navegação programática: `context.push(AppConstants.integrationsRoute)`

## Gerenciamento de Estado

Utiliza **Riverpod** para gerenciamento de estado com:

### Providers Principais:
- `integrationsNotifierProvider` - Provider principal com o StateNotifier
- `integrationsListProvider` - Lista de todas as plataformas
- `connectedPlatformsProvider` - Plataformas conectadas
- `connectionProgressProvider` - Progresso de conexão

### Estados:
- `isLoading` - Estado de carregamento
- `platforms` - Lista de plataformas
- `connectedCount` - Número de plataformas conectadas
- `error` - Mensagens de erro

## UI/UX Features

### Animações:
- Transições suaves nos cards
- Animações de loading durante conexão
- Progress bar animada
- Hover effects nos botões

### Feedback Visual:
- Indicadores de conexão com ícones de check
- Estados diferentes para cada plataforma
- Cores temáticas por plataforma
- Tooltips e mensagens informativas

### Responsividade:
- Layout otimizado para mobile
- Scroll infinito para lista de plataformas
- Footer fixo com ações principais
- Safe areas respeitadas

## Extensibilidade

A arquitetura permite fácil:
- Adição de novas plataformas
- Customização de layouts
- Integração com APIs reais
- Implementação de diferentes tipos de autenticação

## Design System

Segue o design system do app com:
- Cores primárias: `AppTheme.primary` (#e225f4)
- Backgrounds: `AppTheme.backgroundDark` e `AppTheme.backgroundLight`
- Cards: `AppTheme.cardDark`
- Typography consistente
- Border radius padronizado

## Próximos Passos

Para implementações futuras:
1. Integração com APIs reais das plataformas
2. Implementação de OAuth para cada plataforma
3. Sincronização de dados em tempo real
4. Configurações avançadas por plataforma
5. Histórico de conexões
6. Notificações push para novos jogos