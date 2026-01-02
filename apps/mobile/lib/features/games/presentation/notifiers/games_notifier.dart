import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/game.dart';
import '../../domain/usecases/get_user_games.dart';
import '../../domain/usecases/search_games.dart';
import '../../domain/usecases/filter_games.dart';
import '../states/games_state.dart';

class GamesNotifier extends StateNotifier<GamesState> {
  final GetUserGames getUserGames;
  final SearchGames searchGames;
  final FilterGames filterGames;

  GamesNotifier({
    required this.getUserGames,
    required this.searchGames,
    required this.filterGames,
  }) : super(const GamesState());

  Future<void> loadGames(String steamId) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getUserGames(GetUserGamesParams(steamId: steamId));

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (games) {
        state = state.copyWith(
          isLoading: false,
          allGames: games,
          displayGames: games,
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
      (games) {
        state = state.copyWith(
          isRefreshing: false,
          allGames: games,
          displayGames: _applyFiltersAndSearch(games),
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

  void _updateDisplayGames() {
    final filteredGames = _applyFiltersAndSearch(state.allGames);
    state = state.copyWith(displayGames: filteredGames);
  }

  List<Game> _applyFiltersAndSearch(List<Game> games) {
    var filtered = games;

    // Apply filter
    switch (state.selectedFilter) {
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
        filtered = filtered
            .where((game) => game.status == GameStatus.favorite)
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
      case GameFilter.all:
      default:
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
}
