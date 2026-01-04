import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/games_favorites_service.dart';

/// Provider para verificar se um jogo específico é favorito
final isFavoriteProvider = FutureProvider.family<bool, String>((
  ref,
  gameId,
) async {
  return await GamesFavoritesService.isFavoriteGame(gameId);
});

/// Provider para a lista de IDs dos jogos favoritos
final favoritesListProvider = FutureProvider<List<String>>((ref) async {
  return await GamesFavoritesService.getFavorites();
});

/// Provider para o contador de favoritos
final favoritesCountProvider = FutureProvider<int>((ref) async {
  return await GamesFavoritesService.getFavoritesCount();
});

/// Notifier para gerenciar ações de favoritos
class FavoritesNotifier extends StateNotifier<AsyncValue<List<String>>> {
  FavoritesNotifier() : super(const AsyncValue.loading()) {
    _loadFavorites();
  }

  /// Carrega a lista de favoritos
  Future<void> _loadFavorites() async {
    try {
      state = const AsyncValue.loading();
      final favorites = await GamesFavoritesService.getFavorites();
      state = AsyncValue.data(favorites);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Alterna o estado de favorito de um jogo
  Future<bool> toggleFavorite(String gameId) async {
    try {
      final success = await GamesFavoritesService.toggleFavorite(gameId);
      if (success) {
        // Atualiza o estado local
        await _loadFavorites();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Adiciona um jogo aos favoritos
  Future<bool> addToFavorites(String gameId) async {
    try {
      final success = await GamesFavoritesService.addToFavorites(gameId);
      if (success) {
        await _loadFavorites();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Remove um jogo dos favoritos
  Future<bool> removeFromFavorites(String gameId) async {
    try {
      final success = await GamesFavoritesService.removeFromFavorites(gameId);
      if (success) {
        await _loadFavorites();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Limpa todos os favoritos
  Future<bool> clearAllFavorites() async {
    try {
      final success = await GamesFavoritesService.clearFavorites();
      if (success) {
        state = const AsyncValue.data([]);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Força reload dos favoritos
  Future<void> refresh() async {
    await _loadFavorites();
  }
}

/// Provider para o FavoritesNotifier
final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<String>>>(
      (ref) => FavoritesNotifier(),
    );

/// Provider helper para verificar se um jogo é favorito de forma síncrona
final isGameFavoriteProvider = Provider.family<bool, String>((ref, gameId) {
  final favoritesAsync = ref.watch(favoritesNotifierProvider);

  return favoritesAsync.when(
    data: (favorites) => favorites.contains(gameId),
    loading: () => false,
    error: (error, stack) => false,
  );
});
