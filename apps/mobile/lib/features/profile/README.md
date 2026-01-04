# Feature de Profile & Settings

## Visão Geral

Esta feature implementa uma tela completa de perfil e configurações onde os usuários podem visualizar suas estatísticas de jogos, gerenciar plataformas conectadas, configurar integrações e ajustar preferências do app.

## Estrutura

A feature segue o padrão de Clean Architecture utilizado no projeto:

```
lib/features/profile/
├── data/
│   └── models/
│       └── user_stats_model.dart          # Modelo de dados de estatísticas
├── domain/
│   └── entities/
│       └── profile_entities.dart          # Entidades de domínio
├── presentation/
│   ├── pages/
│   │   └── profile_page.dart              # Página principal do perfil
│   ├── providers/
│   │   ├── profile_notifier.dart          # Notifier para gerenciamento de estado
│   │   └── profile_providers.dart         # Providers do Riverpod
│   └── widgets/
│       ├── profile_header.dart            # Header com avatar e informações
│       ├── stats_section.dart             # Seção de estatísticas
│       ├── connected_platforms_section.dart # Plataformas conectadas
│       ├── integrations_section.dart      # Seção de integrações
│       └── settings_section.dart          # Configurações do app
└── profile.dart                           # Arquivo barrel para exports
```

## Funcionalidades

### 1. **Header do Perfil**
- Avatar do usuário com efeito de gradiente
- Username (@NeonRider)
- Badge de membro PRO
- Level do usuário (Lvl 42)
- Botão de edição do perfil

### 2. **Seção de Estatísticas**
- **Jogos**: Número total de jogos (245)
- **Troféus**: Total de troféus conquistados (1.2k)  
- **Tempo**: Total de horas jogadas (850h)
- Cards com ícones e animações

### 3. **Plataformas Conectadas**
- Lista horizontal scrollável
- Indicadores visuais de conexão (verde)
- Plataformas conectadas: Steam, PlayStation
- Plataformas disponíveis: Xbox, Nintendo
- Botão "Manage" que leva para a tela de integrações

### 4. **Integrações**
- **Nexus Mods**: Sincronização automática de mods
- Toggle switch funcional para ativar/desativar
- Status visual (Active/Inactive)

### 5. **Preferências do App**
- **Notifications**: Configurações de notificação
- **Privacy**: Configurações de privacidade
- **Sync Preferences**: Preferências de sincronização (Auto)
- **Wishlist Rules**: Regras da lista de desejos
- **Language**: Configuração de idioma (English)
- Cards organizados com ícones coloridos

### 6. **Ações**
- **Log Out**: Botão de logout com confirmação
- **Versão do App**: Informações da build (GHub v1.0.4 build 209)

## Entidades de Domínio

### UserStats
```dart
class UserStats {
  final int gamesCount;
  final int trophiesCount;  
  final String totalPlayTime;
}
```

### ConnectedPlatform
```dart
class ConnectedPlatform {
  final String id;
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final bool isConnected;
  final String status;
}
```

### Integration
```dart
class Integration {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final bool isActive;
}
```

### SettingItem
```dart
class SettingItem {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final SettingItemType type; // navigation, toggle, selection
  final String? value;
  final VoidCallback? onTap;
}
```

## Gerenciamento de Estado

Utiliza **Riverpod** para gerenciamento de estado com:

### Providers Principais:
- `profileNotifierProvider` - Provider principal com o StateNotifier
- `userStatsProvider` - Estatísticas do usuário
- `connectedPlatformsProvider` - Lista de plataformas
- `integrationsProvider` - Integrações ativas
- `settingsProvider` - Configurações do app

### Estados:
- `isLoading` - Estado de carregamento
- `stats` - Estatísticas do usuário
- `platforms` - Lista de plataformas conectadas
- `integrations` - Lista de integrações
- `settings` - Lista de configurações
- `error` - Mensagens de erro

## Navegação

### Como Acessar:
- **Avatar do Usuário**: Clique no avatar na GamesPage (linha 188)
- **Rota Direta**: `/profile`
- **Navegação Programática**: `context.push(AppConstants.profileRoute)`

### Navegação Interna:
- **Manage Platforms** → Tela de Integrações
- **Settings Items** → Respectivas telas de configuração
- **Back Button** → Volta para a tela anterior

## UI/UX Features

### Design System:
- Cores consistentes com o theme do app
- Modo claro e escuro suportado
- Gradientes e sombras para profundidade
- Border radius padronizado (12px)

### Animações:
- Toggle switches animados
- Transições suaves entre telas
- Hover effects em botões
- Scroll suave nas listas horizontais

### Layout:
- **Scroll Vertical**: CustomScrollView com SliverAppBar
- **Seções Organizadas**: Cada funcionalidade em sua própria seção
- **Espaçamento Consistente**: 16px, 24px, 32px
- **Bottom Navigation**: Consistente com outras telas

## Responsividade

- **Safe Areas**: Respeitadas em todas as telas
- **Overflow Protection**: Scroll horizontal para listas
- **Adaptive Widgets**: Switch.adaptive para diferentes plataformas
- **Mobile First**: Layout otimizado para dispositivos móveis

## Extensibilidade

A arquitetura permite fácil:
- Adição de novas estatísticas
- Inclusão de mais plataformas
- Novas integrações
- Configurações adicionais
- Personalização de temas
- Integração com APIs reais

## Estados dos Dados Mockados

### Estatísticas Padrão:
- 245 jogos
- 1.200 troféus
- 850 horas de jogo

### Plataformas:
- ✅ Steam (conectada)
- ✅ PlayStation (conectada)
- ⭕ Xbox (disponível)
- ⭕ Nintendo (disponível)

### Integrações:
- ✅ Nexus Mods (ativa)

## Próximos Passos

Para implementações futuras:
1. **Integração com APIs** reais de estatísticas
2. **Edição de Perfil** completa
3. **Upload de Avatar** personalizado
4. **Configurações Avançadas** por seção
5. **Notificações Push** personalizadas
6. **Sincronização em Nuvem**
7. **Temas Personalizados**
8. **Análises Detalhadas** de jogos

## Conectividade

- **Games Page**: Avatar clicável navega para profile
- **Integrations Page**: Link "Manage" na seção de plataformas
- **Bottom Navigation**: Navegação consistente entre telas
- **Back Navigation**: GoRouter com histórico preservado

A implementação está **100% funcional** e pronta para uso, seguindo fielmente o design fornecido e mantendo consistência com o resto da aplicação!