# Funcionalidade de Ordenação de Jogos

Esta implementação adiciona a capacidade de ordenar jogos por diferentes critérios na aplicação mobile.

## Componentes Implementados

### 1. UseCase: `SortGames`
- **Localização**: `lib/features/games/domain/usecases/sort_games.dart`
- **Responsabilidade**: Implementa a lógica de ordenação dos jogos
- **Critérios suportados**:
  - `name`: Nome do jogo (A-Z)
  - `lastPlayed`: Data da última partida
  - `releaseDate`: Data de lançamento
  - `rating`: Avaliação do jogo
  - `playtime`: Tempo de jogo total do usuário

### 2. Enums de Configuração
- **`SortCriteria`**: Define os critérios de ordenação disponíveis
- **`SortOrder`**: Define a ordem (crescente/decrescente)

### 3. Atualização do Estado
- **`GamesState`**: Adicionados campos `sortCriteria` e `sortOrder`
- **`GamesNotifier`**: Métodos para gerenciar ordenação:
  - `setSortCriteria(SortCriteria criteria)`
  - `setSortOrder(SortOrder order)`
  - `toggleSortOrder()`

### 4. Interface do Usuário
- **`GamesViewControls`**: Widget atualizado com botão de ordenação
- **`SortBottomSheet`**: Modal com opções de ordenação

## Como Usar

### Programaticamente
```dart
// Definir critério de ordenação
ref.read(gamesNotifierProvider.notifier).setSortCriteria(SortCriteria.name);

// Definir ordem
ref.read(gamesNotifierProvider.notifier).setSortOrder(SortOrder.descending);

// Alternar ordem
ref.read(gamesNotifierProvider.notifier).toggleSortOrder();
```

### Interface do Usuário
1. Na página de jogos, clique no botão de ordenação (ao lado dos controles de visualização)
2. Selecione o critério de ordenação desejado
3. Escolha entre ordem crescente ou decrescente
4. Os jogos serão automaticamente reordenados

## Providers Adicionados
- `currentSortCriteriaProvider`: Acesso ao critério atual
- `currentSortOrderProvider`: Acesso à ordem atual
- `sortGamesProvider`: Provider do usecase de ordenação

## Tratamento de Valores Nulos
- Jogos sem `lastPlayed` são colocados no final da lista
- Jogos sem `releaseDate` são colocados no final da lista  
- Jogos sem `rating` são colocados no final da lista
- Jogos sem `playtimeForever` são colocados no final da lista
- Ordenação por nome é case-insensitive

## Integração
A funcionalidade é automaticamente integrada ao fluxo existente de filtragem e busca, sendo aplicada após os filtros e busca serem processados.