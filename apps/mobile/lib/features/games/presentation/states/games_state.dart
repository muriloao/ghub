import 'package:equatable/equatable.dart';
import '../../domain/entities/game.dart';

enum GameFilter {
  all,
  pc,
  console,
  favorites,
  backlog,
  completed,
  recentlyPlayed,
}

enum GameViewMode { grid, list }

class GamesState extends Equatable {
  final List<Game> allGames;
  final List<Game> displayGames;
  final GameFilter selectedFilter;
  final GameViewMode viewMode;
  final String searchQuery;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const GamesState({
    this.allGames = const [],
    this.displayGames = const [],
    this.selectedFilter = GameFilter.all,
    this.viewMode = GameViewMode.grid,
    this.searchQuery = '',
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  GamesState copyWith({
    List<Game>? allGames,
    List<Game>? displayGames,
    GameFilter? selectedFilter,
    GameViewMode? viewMode,
    String? searchQuery,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return GamesState(
      allGames: allGames ?? this.allGames,
      displayGames: displayGames ?? this.displayGames,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      viewMode: viewMode ?? this.viewMode,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [
    allGames,
    displayGames,
    selectedFilter,
    viewMode,
    searchQuery,
    isLoading,
    isRefreshing,
    errorMessage,
  ];
}
