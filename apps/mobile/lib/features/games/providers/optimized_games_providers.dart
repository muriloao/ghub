import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/optimized_games_cache_service.dart';
import '../../../core/cache/models/game_cache_model.dart';

/// Estado otimizado para jogos usando Hive
class OptimizedGamesState {
  final List<GameCacheModel> games;
  final bool isLoading;
  final String? error;
  final GameStats? stats;

  const OptimizedGamesState({
    this.games = const [],
    this.isLoading = false,
    this.error,
    this.stats,
  });

  OptimizedGamesState copyWith({
    List<GameCacheModel>? games,
    bool? isLoading,
    String? error,
    GameStats? stats,
  }) {
    return OptimizedGamesState(
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
    );
  }
}

/// Notifier otimizado para jogos com cache Hive
class OptimizedGamesNotifier extends StateNotifier<OptimizedGamesState> {
  OptimizedGamesNotifier() : super(const OptimizedGamesState()) {
    _loadCachedGames();
  }

  /// Carrega jogos do cache (muito rápido)
  void _loadCachedGames() {
    try {
      final cachedGames = OptimizedGamesCacheService.getCachedSteamGames();
      final stats = OptimizedGamesCacheService.getGameStats();

      state = state.copyWith(
        games: cachedGames,
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Erro ao carregar jogos do cache: $e',
        isLoading: false,
      );
    }
  }

  /// Força sincronização com API se necessário
  Future<void> syncIfNeeded() async {
    final shouldSync = await OptimizedGamesCacheService.shouldSync();

    if (shouldSync) {
      // Aqui você integraria com seu serviço de API Steam
      // Por enquanto, apenas recarrega do cache
      _loadCachedGames();
    }
  }

  /// Busca jogos com filtros otimizados
  void searchGames({String? query, bool? favoritesOnly, String? platform}) {
    try {
      final filteredGames = OptimizedGamesCacheService.searchGames(
        query: query,
        favoritesOnly: favoritesOnly,
        platform: platform,
      );

      state = state.copyWith(games: filteredGames);
    } catch (e) {
      state = state.copyWith(error: 'Erro na busca: $e');
    }
  }

  /// Alterna favorito de um jogo
  Future<void> toggleFavorite(String gameId) async {
    try {
      await OptimizedGamesCacheService.toggleGameFavorite(gameId);
      _loadCachedGames(); // Recarrega para atualizar UI
    } catch (e) {
      state = state.copyWith(error: 'Erro ao alterar favorito: $e');
    }
  }

  /// Atualiza estatísticas
  void updateStats() {
    final stats = OptimizedGamesCacheService.getGameStats();
    state = state.copyWith(stats: stats);
  }

  /// Limpa erro
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ====== PROVIDERS ======

/// Provider principal para jogos otimizados
final optimizedGamesProvider =
    StateNotifierProvider<OptimizedGamesNotifier, OptimizedGamesState>((ref) {
      return OptimizedGamesNotifier();
    });

/// Provider para lista de jogos
final optimizedGamesListProvider = Provider<List<GameCacheModel>>((ref) {
  return ref.watch(optimizedGamesProvider).games;
});

/// Provider para estatísticas
final gamesStatsProvider = Provider<GameStats?>((ref) {
  return ref.watch(optimizedGamesProvider).stats;
});

/// Provider para jogos favoritos
final favoriteGamesProvider = Provider<List<GameCacheModel>>((ref) {
  final games = ref.watch(optimizedGamesListProvider);
  return games.where((game) => game.isFavorite).toList();
});

/// Provider para contagem total
final totalGamesCountProvider = Provider<int>((ref) {
  return ref.watch(optimizedGamesListProvider).length;
});

/// Provider para verificar se está carregando
final isGamesLoadingProvider = Provider<bool>((ref) {
  return ref.watch(optimizedGamesProvider).isLoading;
});

/// Provider para erros
final gamesErrorProvider = Provider<String?>((ref) {
  return ref.watch(optimizedGamesProvider).error;
});
