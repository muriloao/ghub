import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/game.dart';
import '../../domain/usecases/get_user_games.dart';
import '../../domain/usecases/search_games.dart';
import '../../domain/usecases/filter_games.dart';
import '../../domain/usecases/sort_games.dart';
import '../states/games_state.dart';
import '../../../../core/services/games_favorites_service.dart';

class GamesNotifier extends StateNotifier<GamesState> {
  final GetUserGames getUserGames;
  final SearchGames searchGames;
  final FilterGames filterGames;
  final SortGames sortGames;

  GamesNotifier({
    required this.getUserGames,
    required this.searchGames,
    required this.filterGames,
    required this.sortGames,
  }) : super(const GamesState());

  Future<void> loadGames(String steamId) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getUserGames(GetUserGamesParams(steamId: steamId));

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (games) async {
        final filteredGames = await _applyFiltersAndSearch(games);
        final sortedGames = await _applySorting(filteredGames);
        state = state.copyWith(
          isLoading: false,
          allGames: games,
          displayGames: sortedGames,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> refreshGames(String steamId) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);

    final result = await getUserGames(GetUserGamesParams(steamId: steamId));

    result.fold(
      (failure) {
        state = state.copyWith(
          isRefreshing: false,
          errorMessage: failure.message,
        );
      },
      (games) async {
        final filteredGames = await _applyFiltersAndSearch(games);
        final sortedGames = await _applySorting(filteredGames);
        state = state.copyWith(
          isRefreshing: false,
          allGames: games,
          displayGames: sortedGames,
          errorMessage: null,
        );
      },
    );
  }

  void clearSearch() {
    setSearchQuery('');
  }

  void setFilter(GameFilter filter) {
    state = state.copyWith(selectedFilter: filter);
    _updateDisplayGames();
  }

  void setViewMode(GameViewMode viewMode) {
    state = state.copyWith(viewMode: viewMode);
  }

  void toggleViewMode() {
    final newMode = state.viewMode == GameViewMode.grid
        ? GameViewMode.list
        : GameViewMode.grid;
    setViewMode(newMode);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _updateDisplayGames();
  }

  void setSortCriteria(SortCriteria criteria) {
    state = state.copyWith(sortCriteria: criteria);
    _updateDisplayGames();
  }

  void setSortOrder(SortOrder order) {
    state = state.copyWith(sortOrder: order);
    _updateDisplayGames();
  }

  void toggleSortOrder() {
    final newOrder = state.sortOrder == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;
    setSortOrder(newOrder);
  }

  /// Atualiza os filtros após mudança nos favoritos
  Future<void> refreshFilters() async {
    _updateDisplayGames();
  }

  void _updateDisplayGames() {
    _applyFiltersAndSearchAsync();
  }

  Future<void> _applyFiltersAndSearchAsync() async {
    final filteredGames = await _applyFiltersAndSearch(state.allGames);
    final sortedGames = await _applySorting(filteredGames);
    state = state.copyWith(displayGames: sortedGames);
  }

  Future<List<Game>> _applyFiltersAndSearch(List<Game> games) async {
    var filtered = games;

    // Apply filter
    switch (state.selectedFilter) {
      case GameFilter.all:
        // No additional filtering needed
        break;
      case GameFilter.pc:
        filtered = filtered
            .where((game) => game.platforms.contains(GamePlatform.pc))
            .toList();
        break;
      case GameFilter.console:
        filtered = filtered
            .where(
              (game) =>
                  game.platforms.any((platform) => platform != GamePlatform.pc),
            )
            .toList();
        break;
      case GameFilter.favorites:
        // Busca favoritos do cache local
        final favoriteIds = await GamesFavoritesService.getFavorites();
        filtered = filtered
            .where((game) => favoriteIds.contains(game.id))
            .toList();
        break;
      case GameFilter.backlog:
        filtered = filtered
            .where((game) => game.status == GameStatus.backlog)
            .toList();
        break;
      case GameFilter.completed:
        filtered = filtered
            .where((game) => game.status == GameStatus.completed)
            .toList();
        break;
      case GameFilter.recentlyPlayed:
        // Jogos jogados nas últimas 2 semanas
        filtered = filtered
            .where(
              (game) => game.playtime2Weeks != null && game.playtime2Weeks! > 0,
            )
            .toList();
        break;
    }

    // Apply search
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (game) => game.name.toLowerCase().contains(
              state.searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }

    return filtered;
  }

  Future<List<Game>> _applySorting(List<Game> games) async {
    final result = await sortGames(
      SortGamesParams(
        games: games,
        criteria: state.sortCriteria,
        order: state.sortOrder,
      ),
    );

    return result.fold((failure) {
      // Em caso de erro na ordenação, retorna os jogos sem ordenar
      return games;
    }, (sortedGames) => sortedGames);
  }
}
