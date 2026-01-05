# Steam Achievements Integration

Esta implementação adiciona suporte completo a achievements da Steam API no GHub, seguindo o design da página fornecida.

## 🏆 Funcionalidades Implementadas

### ✅ Modelos de Dados Completos
- **SteamAchievementModel**: Achievements do usuário
- **SteamAchievementSchemaModel**: Informações globais dos achievements
- **CompleteSteamAchievementModel**: Modelo combinado completo
- **AchievementStats**: Estatísticas e métricas

### ✅ Integração Steam API
- **Busca de achievements do usuário**: `GetPlayerAchievements`
- **Schema de achievements**: `GetSchemaForGame`
- **Percentuais globais**: `GetGlobalAchievementPercentagesForApp`
- **Dados combinados e organizados**: Todos os dados em um só lugar

### ✅ Interface de Usuário Completa
- **Achievement Cards**: Cards individuais com ícone, nome, descrição
- **Filtros avançados**: Todos, Desbloqueados, Bloqueados, Raros
- **Estatísticas visuais**: Progresso circular, barras de progresso
- **Badges de raridade**: Comum, Incomum, Raro
- **Design responsivo**: Seguindo o design da page.html

## 🎮 Como Usar

### 1. Na Página de Detalhes do Jogo

A seção de achievements é automaticamente integrada na aba "Achievements":

```dart
// Em GameDetailPage, a aba de achievements agora usa:
Widget _buildAchievementsTab(Game game) {
  return GameAchievementsSection(
    appId: game.id,
    gameName: game.name,
  );
}
```

### 2. Uso Direto da Seção

Você pode usar a seção de achievements em qualquer lugar:

```dart
GameAchievementsSection(
  appId: '1091500', // Cyberpunk 2077
  gameName: 'Cyberpunk 2077',
)
```

### 3. Providers Disponíveis

```dart
// Lista de achievements (com filtros aplicados)
final achievements = ref.watch(gameAchievementsProvider(appId));

// Estatísticas dos achievements
final stats = ref.watch(gameAchievementsStatsProvider(appId));

// Estado de carregamento
final isLoading = ref.watch(gameAchievementsLoadingProvider(appId));

// Controle de filtros
ref.read(gameAchievementsNotifierProvider(appId).notifier)
   .setFilter(AchievementFilter.rare);
```

## 🔧 Configuração

### 1. Steam API Key
Certifique-se que a Steam API Key está configurada em:
```dart
// lib/core/config/steam_config.dart
static const String apiKey = 'SUA_STEAM_API_KEY';
```

### 2. Dependências
As seguintes dependências foram adicionadas automaticamente:
- `cached_network_image: ^3.4.1` - Para cache de ícones de achievements

## 🎯 Funcionalidades da Interface

### Achievement Cards
- **Ícone do achievement** (colorido se desbloqueado, cinza se não)
- **Nome e descrição** do achievement
- **Badge de raridade** (Comum/Incomum/Raro baseado no % global)
- **Barra de progresso** visual
- **Data de desbloqueio** ou status
- **Percentual global** de jogadores que têm o achievement

### Filtros
- **Todos**: Todos os achievements
- **Desbloqueados**: Apenas achievements obtidos
- **Bloqueados**: Apenas achievements não obtidos  
- **Raros**: Achievements com < 5% de taxa global

### Estatísticas
- **Progresso circular** visual da completude
- **Contador**: X/Y achievements desbloqueados
- **Achievements raros**: Quantos raros foram desbloqueados
- **Barra de progresso** horizontal

## 🎨 Design System

### Cores e Temas
- **Primary**: `#e225f4` (roxo do app)
- **Background Dark**: `#211022`
- **Surface**: `#2d1b2e`
- **Badges**: Cores diferentes por raridade

### Raridade por Cor
- **Comum**: Cinza (`Colors.grey`)
- **Incomum**: Laranja (`Colors.orange`)
- **Raro**: Roxo primary (`AppTheme.primary`)

### Estados Visuais
- **Desbloqueado**: Ícone colorido, texto branco, barra roxa
- **Bloqueado**: Ícone cinza, texto acinzentado, sem brilho
- **Loading**: Shimmer/skeleton loading
- **Erro**: Estado de erro com botão de retry

## 📊 API Endpoints Usados

### 1. Player Achievements
```
GET /ISteamUserStats/GetPlayerAchievements/v0001/
- key: Steam API Key
- steamid: Steam ID do usuário  
- appid: ID do jogo
```

### 2. Achievement Schema
```
GET /ISteamUserStats/GetSchemaForGame/v2/
- key: Steam API Key
- appid: ID do jogo
```

### 3. Global Achievement Percentages
```
GET /ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/
- gameid: ID do jogo
```

## 🔄 Fluxo de Dados

1. **Carregamento**: Busca paralela de dados do usuário, schema e percentuais
2. **Combinação**: Combina todos os dados em `CompleteSteamAchievementModel`
3. **Organização**: Ordena por status → raridade → alfabético
4. **Cache**: Armazena dados para acesso offline
5. **Filtros**: Aplica filtros em tempo real
6. **UI**: Renderiza cards com todas as informações

## 🧪 Testando

### Jogos Recomendados para Teste
- **Cyberpunk 2077** (`1091500`) - ~40 achievements
- **Red Dead Redemption 2** (`1174180`) - ~50+ achievements  
- **Skyrim Special Edition** (`489830`) - ~75 achievements
- **The Witcher 3** (`292030`) - ~78 achievements

### Página de Demo
Criada uma página de demonstração em:
```dart
// lib/features/demo/achievements_demo_page.dart
// Mostra achievements de vários jogos populares
```

## 🚀 Performance

### Otimizações
- **Busca paralela**: Todas APIs são chamadas simultaneamente
- **Cache de imagens**: Ícones são cached automaticamente
- **Lazy loading**: Dados só são buscados quando necessário
- **Filtros rápidos**: Filtros aplicados em memória, sem nova API call

### Rate Limiting
- Respeitado delay entre requisições para evitar rate limits
- Fallbacks para dados indisponíveis
- Tratamento gracioso de erros de API

## 🔮 Possíveis Expansões

1. **Comparação com amigos** (botão já existe na UI)
2. **Achievements ocultos** (suporte já implementado)
3. **Histórico de desbloqueios** 
4. **Notificações de novos achievements**
5. **Integração com outras plataformas** (Xbox, PlayStation)
6. **Achievements personalizados do app**

## 💡 Uso Avançado

### Customização de Filtros
```dart
// Criar filtros personalizados
enum CustomFilter {
  recentlyUnlocked,
  hardToGet,
  storyRelated,
}
```

### Achievement Details Modal
```dart
// Implementar modal de detalhes (preparado na UI)
void _showAchievementDetails(CompleteSteamAchievementModel achievement) {
  // Mostrar modal com informações completas
  // Dicas, guias, estatísticas detalhadas, etc.
}
```

A implementação está completa e pronta para uso! 🎉