import 'package:equatable/equatable.dart';
import 'package:ghub_mobile/features/auth/domain/entities/user.dart';
import '../../domain/entities/game.dart';
import '../../domain/usecases/sort_games.dart';
import '../../../onboarding/domain/entities/gaming_platform.dart';

enum GameFilter { all, favorites, backlog, completed, recentlyPlayed }

// Classe para filtros de plataforma dinâmicos
class PlatformFilter {
  final PlatformType platformType;
  final String displayName;

  const PlatformFilter({required this.platformType, required this.displayName});
}

enum GameViewMode { grid, list }

class GamesState extends Equatable {
  final User? user;
  final List<Game> allGames;
  final List<Game> displayGames;
  final GameFilter selectedFilter;
  final PlatformType? selectedPlatform; // Filtro de plataforma selecionado
  final List<PlatformType> availablePlatforms; // Plataformas disponíveis
  final GameViewMode viewMode;
  final String searchQuery;
  final SortCriteria sortCriteria;
  final SortOrder sortOrder;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const GamesState({
    this.user,
    this.allGames = const [],
    this.displayGames = const [],
    this.selectedFilter = GameFilter.all,
    this.selectedPlatform,
    this.availablePlatforms = const [],
    this.viewMode = GameViewMode.grid,
    this.searchQuery = '',
    this.sortCriteria = SortCriteria.name,
    this.sortOrder = SortOrder.ascending,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  GamesState copyWith({
    User? user,
    List<Game>? allGames,
    List<Game>? displayGames,
    GameFilter? selectedFilter,
    PlatformType? selectedPlatform,
    List<PlatformType>? availablePlatforms,
    GameViewMode? viewMode,
    String? searchQuery,
    SortCriteria? sortCriteria,
    SortOrder? sortOrder,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return GamesState(
      user: user ?? this.user,
      allGames: allGames ?? this.allGames,
      displayGames: displayGames ?? this.displayGames,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
      availablePlatforms: availablePlatforms ?? this.availablePlatforms,
      viewMode: viewMode ?? this.viewMode,
      searchQuery: searchQuery ?? this.searchQuery,
      sortCriteria: sortCriteria ?? this.sortCriteria,
      sortOrder: sortOrder ?? this.sortOrder,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [
    user,
    allGames,
    displayGames,
    selectedFilter,
    selectedPlatform,
    availablePlatforms,
    viewMode,
    searchQuery,
    sortCriteria,
    sortOrder,
    isLoading,
    isRefreshing,
    errorMessage,
  ];
}
