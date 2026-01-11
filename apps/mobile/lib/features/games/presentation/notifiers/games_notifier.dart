import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghub_mobile/features/integrations/integrations.dart';
import '../../domain/entities/game.dart';
import '../../domain/usecases/get_user_games.dart';
import '../../domain/usecases/search_games.dart';
import '../../domain/usecases/filter_games.dart';
import '../../domain/usecases/sort_games.dart';
import '../states/games_state.dart';
import '../../../../core/services/games_favorites_service.dart';
import 'package:ghub_mobile/features/integrations/domain/entities/gaming_platform.dart';
import '../../services/games_preferences_service.dart';

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

  /// Carrega as preferências salvas do usuário
  Future<void> loadSavedPreferences() async {
    try {
      final sortPrefs = await GamesPreferencesService.getSortPreferences();
      final filterPrefs = await GamesPreferencesService.getFilterPreferences();

      state = state.copyWith(
        sortCriteria: sortPrefs['criteria'] as SortCriteria,
        sortOrder: sortPrefs['order'] as SortOrder,
        selectedFilter: filterPrefs['filter'] as GameFilter,
        selectedPlatform: filterPrefs['platform'] as PlatformType?,
      );
    } catch (e) {
      // Se houver erro ao carregar preferências, mantém valores padrão
      // Não faz nada, o estado já tem valores padrão
    }
  }

  Future<void> loadGames(String steamId) async {
    if (state.isLoading) return;

    // Carrega preferências salvas antes de carregar os jogos
    await loadSavedPreferences();

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getUserGames(GetUserGamesParams(steamId: steamId));

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (games) async {
        final filteredGames = await _applyFiltersAndSearch(games);
        final sortedGames = await _applySorting(filteredGames);
        final availablePlatforms = _extractAvailablePlatforms(games);
        state = state.copyWith(
          isLoading: false,
          allGames: games,
          displayGames: sortedGames,
          availablePlatforms: availablePlatforms,
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
        final availablePlatforms = _extractAvailablePlatforms(games);
        state = state.copyWith(
          isRefreshing: false,
          allGames: games,
          displayGames: sortedGames,
          availablePlatforms: availablePlatforms,
          errorMessage: null,
        );
      },
    );
  }

  void clearSearch() {
    setSearchQuery('');
  }

  void setFilter(GameFilter filter) {
    state = state.copyWith(selectedFilter: filter, selectedPlatform: null);
    _updateDisplayGames();
    _saveFilterPreferences();
  }

  void setPlatformFilter(PlatformType platformType) {
    state = state.copyWith(
      selectedFilter: GameFilter.all,
      selectedPlatform: platformType,
    );
    _updateDisplayGames();
    _saveFilterPreferences();
  }

  void clearPlatformFilter() {
    state = state.copyWith(selectedPlatform: null);
    _updateDisplayGames();
    _saveFilterPreferences();
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
    _saveSortPreferences();
  }

  void setSortOrder(SortOrder order) {
    state = state.copyWith(sortOrder: order);
    _updateDisplayGames();
    _saveSortPreferences();
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

    // Apply platform filter
    if (state.selectedPlatform != null) {
      filtered = filtered
          .where((game) => game.sourcePlatform == state.selectedPlatform)
          .toList();
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

  List<PlatformType> _extractAvailablePlatforms(List<Game> games) {
    final platformsSet = <PlatformType>{};

    for (final game in games) {
      if (game.sourcePlatform != null) {
        platformsSet.add(game.sourcePlatform!);
      }
    }

    return platformsSet.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Salva as preferências de ordenação
  void _saveSortPreferences() {
    GamesPreferencesService.saveSortPreferences(
      criteria: state.sortCriteria,
      order: state.sortOrder,
    ).catchError((error) {
      // Ignora erros ao salvar preferências para não quebrar a funcionalidade
    });
  }

  /// Salva as preferências de filtros
  void _saveFilterPreferences() {
    GamesPreferencesService.saveFilterPreferences(
      filter: state.selectedFilter,
      platform: state.selectedPlatform,
    ).catchError((error) {
      // Ignora erros ao salvar preferências para não quebrar a funcionalidade
    });
  }
}
