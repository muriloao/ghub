# Funcionalidade de Ordenação, Filtragem Dinâmica e Cache de Preferências

Esta implementação adiciona a capacidade de ordenar jogos por diferentes critérios, filtrar por plataformas dinâmicas e salvar as preferências do usuário na aplicação mobile.

## Componentes Implementados

### 1. Sistema de Cache de Preferências
- **Serviço**: `GamesPreferencesService` - Gerencia persistência de preferências
- **Armazenamento**: Utiliza `SharedPreferences` para cache local
- **Auto-save**: Preferências são salvas automaticamente quando alteradas
- **Auto-load**: Preferências são carregadas automaticamente na inicialização

### 2. Filtragem Dinâmica por Plataforma
- **Campo `sourcePlatform`**: Adicionado à entidade `Game` para identificar a plataforma de origem
- **Filtros dinâmicos**: Os filtros de plataforma são gerados automaticamente com base nos jogos carregados
- **Suporte a múltiplas plataformas**: Steam, Xbox, PlayStation, Epic Games, GOG, Nintendo, Origin, Uplay
- **Cache persistente**: Última plataforma selecionada é lembrada

### 3. UseCase: `SortGames`
- **Localização**: `lib/features/games/domain/usecases/sort_games.dart`
- **Responsabilidade**: Implementa a lógica de ordenação dos jogos
- **Critérios suportados**:
  - `name`: Nome do jogo (A-Z)
  - `lastPlayed`: Data da última partida
  - `releaseDate`: Data de lançamento
  - `rating`: Avaliação do jogo
  - `playtime`: Tempo de jogo total do usuário
- **Cache persistente**: Último critério e ordem são lembrados

## Como o Cache Funciona

### Dados Persistidos
1. **Critério de ordenação** (`SortCriteria`)
2. **Ordem de ordenação** (`SortOrder`) 
3. **Filtro selecionado** (`GameFilter`)
4. **Plataforma selecionada** (`PlatformType`)

### Fluxo de Funcionamento
1. **Carregamento**: Ao inicializar, `loadSavedPreferences()` é chamado
2. **Aplicação**: Preferências salvas são aplicadas ao estado inicial
3. **Auto-save**: Qualquer alteração dispara o salvamento automático
4. **Recuperação**: Na próxima inicialização, as preferências são restauradas

### Métodos Principais
```dart
// Carregar preferências (chamado automaticamente)
await loadSavedPreferences();

// As alterações são salvas automaticamente:
setSortCriteria(SortCriteria.playtime);  // Salva automaticamente
setSortOrder(SortOrder.descending);      // Salva automaticamente
setPlatformFilter(PlatformType.steam);   // Salva automaticamente

// Limpar todas as preferências
await GamesPreferencesService.clearPreferences();
```

## Como Usar

### Experiência do Usuário
1. **Primeira vez**: Usuário vê configurações padrão
2. **Personalização**: Usuário altera ordenação e filtros conforme preferência
3. **Persistência**: Configurações são salvas automaticamente
4. **Continuidade**: Na próxima abertura, suas preferências são restauradas

### Para Desenvolvedores
- **Auto-gerenciado**: Sistema funciona automaticamente, sem intervenção necessária
- **Error-safe**: Falhas no cache não quebram a funcionalidade (fallback para padrão)
- **Extensível**: Fácil adicionar novas preferências ao serviço

## Providers e Serviços

### Cache Service
- `GamesPreferencesService.saveSortPreferences()` - Salva ordenação
- `GamesPreferencesService.saveFilterPreferences()` - Salva filtros
- `GamesPreferencesService.getSortPreferences()` - Recupera ordenação
- `GamesPreferencesService.getFilterPreferences()` - Recupera filtros

### Providers Existentes
- `selectedPlatformProvider`: Plataforma selecionada (com cache)
- `availablePlatformsProvider`: Lista de plataformas disponíveis
- `currentSortCriteriaProvider`: Critério atual de ordenação (com cache)
- `currentSortOrderProvider`: Ordem atual de ordenação (com cache)

## Tratamento de Erros
- **Graceful failure**: Erros de cache não afetam funcionalidade principal
- **Fallback seguro**: Sempre usa valores padrão se cache falhar
- **Logging silencioso**: Erros são capturados sem interromper UX

## Benefícios da Implementação
- **UX Personalizada**: Cada usuário mantém suas preferências
- **Performance**: Não há delay na aplicação de filtros salvos
- **Confiabilidade**: Sistema robusto com fallbacks apropriados
- **Escalabilidade**: Estrutura permite adicionar novas preferências facilmente