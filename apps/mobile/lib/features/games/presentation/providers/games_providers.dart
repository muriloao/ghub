import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:ghub_mobile/features/integrations/domain/entities/gaming_platform.dart';
import '../../domain/entities/game.dart';
import '../../data/datasources/games_remote_data_source.dart';
import '../../data/datasources/games_remote_data_source_impl.dart';
import '../../data/services/steam_games_service.dart';
import '../../data/repositories/games_repository_impl.dart';
import '../../domain/repositories/games_repository.dart';
import '../../domain/usecases/get_user_games.dart';
import '../../domain/usecases/search_games.dart';
import '../../domain/usecases/filter_games.dart';
import '../../domain/usecases/sort_games.dart';
import '../notifiers/games_notifier.dart';
import '../states/games_state.dart';

// Data Sources
final gamesRemoteDataSourceProvider = Provider<GamesRemoteDataSource>((ref) {
  final dio = Dio();
  return GamesRemoteDataSourceImpl(dio);
});

// Services
final steamGamesServiceProvider = Provider<SteamGamesService>((ref) {
  final dio = Dio();
  return SteamGamesService(dio);
});

// Repository
final gamesRepositoryProvider = Provider<GamesRepository>((ref) {
  final remoteDataSource = ref.watch(gamesRemoteDataSourceProvider);
  final steamGamesService = ref.watch(steamGamesServiceProvider);

  return GamesRepositoryImpl(
    remoteDataSource: remoteDataSource,
    steamGamesService: steamGamesService,
  );
});

// Use Cases
final getUserGamesProvider = Provider<GetUserGames>((ref) {
  final repository = ref.watch(gamesRepositoryProvider);
  return GetUserGames(repository);
});

final searchGamesProvider = Provider<SearchGames>((ref) {
  final repository = ref.watch(gamesRepositoryProvider);
  return SearchGames(repository);
});

final filterGamesProvider = Provider<FilterGames>((ref) {
  final repository = ref.watch(gamesRepositoryProvider);
  return FilterGames(repository);
});

final sortGamesProvider = Provider<SortGames>((ref) {
  return SortGames();
});

// Main Notifier
final gamesNotifierProvider = StateNotifierProvider<GamesNotifier, GamesState>((
  ref,
) {
  final getUserGames = ref.watch(getUserGamesProvider);
  final searchGames = ref.watch(searchGamesProvider);
  final filterGames = ref.watch(filterGamesProvider);
  final sortGames = ref.watch(sortGamesProvider);

  return GamesNotifier(
    getUserGames: getUserGames,
    searchGames: searchGames,
    filterGames: filterGames,
    sortGames: sortGames,
  );
});

// Convenience Providers
final gamesListProvider = Provider<List<Game>>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.displayGames;
});

final gamesCountProvider = Provider<int>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.displayGames.length;
});

final isLoadingGamesProvider = Provider<bool>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.isLoading || state.isRefreshing;
});

final hasGamesErrorProvider = Provider<bool>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.hasError;
});

final gamesErrorMessageProvider = Provider<String?>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.errorMessage;
});

final currentGameFilterProvider = Provider<GameFilter>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.selectedFilter;
});

final selectedPlatformProvider = Provider<PlatformType?>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.selectedPlatform;
});

final availablePlatformsProvider = Provider<List<PlatformType>>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.availablePlatforms;
});

final currentViewModeProvider = Provider<GameViewMode>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.viewMode;
});

final searchQueryProvider = Provider<String>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.searchQuery;
});

final currentSortCriteriaProvider = Provider<SortCriteria>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.sortCriteria;
});

final currentSortOrderProvider = Provider<SortOrder>((ref) {
  final state = ref.watch(gamesNotifierProvider);
  return state.sortOrder;
});

// Provider para buscar um jogo específico por ID
final gameByIdProvider = Provider.family<Game?, String>((ref, gameId) {
  final games = ref.watch(gamesListProvider);
  try {
    return games.firstWhere((game) => game.id == gameId);
  } catch (e) {
    return null;
  }
});
