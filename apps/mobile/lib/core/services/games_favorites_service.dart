import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de cache para gerenciar favoritos dos jogos
class GamesFavoritesService {
  static const String _favoritesKey = 'games_favorites';

  /// Adiciona um jogo aos favoritos
  static Future<bool> addToFavorites(String gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      if (!favorites.contains(gameId)) {
        favorites.add(gameId);
        return await prefs.setStringList(_favoritesKey, favorites);
      }

      return true; // Já está nos favoritos
    } catch (e) {
      return false;
    }
  }

  /// Remove um jogo dos favoritos
  static Future<bool> removeFromFavorites(String gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      favorites.remove(gameId);
      return await prefs.setStringList(_favoritesKey, favorites);
    } catch (e) {
      return false;
    }
  }

  /// Alterna o estado de favorito de um jogo
  static Future<bool> toggleFavorite(String gameId) async {
    final isFavorite = await isFavoriteGame(gameId);

    if (isFavorite) {
      return await removeFromFavorites(gameId);
    } else {
      return await addToFavorites(gameId);
    }
  }

  /// Verifica se um jogo está nos favoritos
  static Future<bool> isFavoriteGame(String gameId) async {
    try {
      final favorites = await getFavorites();
      return favorites.contains(gameId);
    } catch (e) {
      return false;
    }
  }

  /// Recupera a lista de favoritos
  static Future<List<String>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesStringList = prefs.getStringList(_favoritesKey) ?? [];
      return List<String>.from(favoritesStringList);
    } catch (e) {
      return [];
    }
  }

  /// Limpa todos os favoritos
  static Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_favoritesKey);
    } catch (e) {
      return false;
    }
  }

  /// Obtém o total de jogos favoritos
  static Future<int> getFavoritesCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }
}
