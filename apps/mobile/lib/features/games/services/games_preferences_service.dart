import 'package:shared_preferences/shared_preferences.dart';
import '../domain/usecases/sort_games.dart';
import '../presentation/states/games_state.dart';
import '../../onboarding/domain/entities/gaming_platform.dart';

class GamesPreferencesService {
  static const String _sortCriteriaKey = 'games_sort_criteria';
  static const String _sortOrderKey = 'games_sort_order';
  static const String _selectedFilterKey = 'games_selected_filter';
  static const String _selectedPlatformKey = 'games_selected_platform';

  /// Salva as preferências de ordenação
  static Future<void> saveSortPreferences({
    required SortCriteria criteria,
    required SortOrder order,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sortCriteriaKey, criteria.name);
    await prefs.setString(_sortOrderKey, order.name);
  }

  /// Recupera as preferências de ordenação salvas
  static Future<Map<String, dynamic>> getSortPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final criteriaName = prefs.getString(_sortCriteriaKey);
    final orderName = prefs.getString(_sortOrderKey);

    SortCriteria criteria = SortCriteria.name; // padrão
    SortOrder order = SortOrder.ascending; // padrão

    // Converte string para enum SortCriteria
    if (criteriaName != null) {
      criteria = SortCriteria.values.firstWhere(
        (e) => e.name == criteriaName,
        orElse: () => SortCriteria.name,
      );
    }

    // Converte string para enum SortOrder
    if (orderName != null) {
      order = SortOrder.values.firstWhere(
        (e) => e.name == orderName,
        orElse: () => SortOrder.ascending,
      );
    }

    return {'criteria': criteria, 'order': order};
  }

  /// Salva as preferências de filtro
  static Future<void> saveFilterPreferences({
    required GameFilter filter,
    PlatformType? platform,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedFilterKey, filter.name);

    if (platform != null) {
      await prefs.setString(_selectedPlatformKey, platform.name);
    } else {
      await prefs.remove(_selectedPlatformKey);
    }
  }

  /// Recupera as preferências de filtro salvas
  static Future<Map<String, dynamic>> getFilterPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final filterName = prefs.getString(_selectedFilterKey);
    final platformName = prefs.getString(_selectedPlatformKey);

    GameFilter filter = GameFilter.all; // padrão
    PlatformType? platform;

    // Converte string para enum GameFilter
    if (filterName != null) {
      filter = GameFilter.values.firstWhere(
        (e) => e.name == filterName,
        orElse: () => GameFilter.all,
      );
    }

    // Converte string para enum PlatformType
    if (platformName != null) {
      try {
        platform = PlatformType.values.firstWhere(
          (e) => e.name == platformName,
        );
      } catch (e) {
        // Se não encontrar, mantém null
        platform = null;
      }
    }

    return {'filter': filter, 'platform': platform};
  }

  /// Limpa todas as preferências salvas
  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sortCriteriaKey);
    await prefs.remove(_sortOrderKey);
    await prefs.remove(_selectedFilterKey);
    await prefs.remove(_selectedPlatformKey);
  }
}
