import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../games/data/services/steam_games_service.dart';
import '../../games/data/models/steam_achievement_model.dart';
import '../../../core/services/cache_service.dart';

/// Provider do SteamGamesService
final steamGamesServiceProvider = Provider<SteamGamesService>((ref) {
  return SteamGamesService(Dio());
});

/// Estado dos achievements de um jogo
class GameAchievementsState {
  final List<CompleteSteamAchievementModel> achievements;
  final bool isLoading;
  final String? error;
  final AchievementFilter filter;

  const GameAchievementsState({
    this.achievements = const [],
    this.isLoading = false,
    this.error,
    this.filter = AchievementFilter.all,
  });

  GameAchievementsState copyWith({
    List<CompleteSteamAchievementModel>? achievements,
    bool? isLoading,
    String? error,
    AchievementFilter? filter,
  }) {
    return GameAchievementsState(
      achievements: achievements ?? this.achievements,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
    );
  }

  /// Lista filtrada de achievements baseada no filtro atual
  List<CompleteSteamAchievementModel> get filteredAchievements {
    switch (filter) {
      case AchievementFilter.all:
        return achievements;
      case AchievementFilter.unlocked:
        return achievements.where((a) => a.isUnlocked).toList();
      case AchievementFilter.locked:
        return achievements.where((a) => !a.isUnlocked).toList();
      case AchievementFilter.rare:
        return achievements
            .where((a) => a.rarity == AchievementRarity.rare)
            .toList();
      case AchievementFilter.hidden:
        return achievements.where((a) => a.schema.isHidden).toList();
    }
  }

  /// Estatísticas dos achievements
  AchievementStats get stats {
    final total = achievements.length;
    final unlocked = achievements.where((a) => a.isUnlocked).length;
    final rare = achievements
        .where((a) => a.rarity == AchievementRarity.rare)
        .length;
    final rareUnlocked = achievements
        .where((a) => a.rarity == AchievementRarity.rare && a.isUnlocked)
        .length;

    return AchievementStats(
      total: total,
      unlocked: unlocked,
      rare: rare,
      rareUnlocked: rareUnlocked,
      progress: total > 0 ? unlocked / total : 0.0,
    );
  }
}

/// Filtros para achievements
enum AchievementFilter { all, unlocked, locked, rare, hidden }

extension AchievementFilterExtension on AchievementFilter {
  String get displayName {
    switch (this) {
      case AchievementFilter.all:
        return 'Todos';
      case AchievementFilter.unlocked:
        return 'Desbloqueados';
      case AchievementFilter.locked:
        return 'Bloqueados';
      case AchievementFilter.rare:
        return 'Raros';
      case AchievementFilter.hidden:
        return 'Ocultos';
    }
  }

  String get displayNameEn {
    switch (this) {
      case AchievementFilter.all:
        return 'All';
      case AchievementFilter.unlocked:
        return 'Unlocked';
      case AchievementFilter.locked:
        return 'Locked';
      case AchievementFilter.rare:
        return 'Rare';
      case AchievementFilter.hidden:
        return 'Hidden';
    }
  }
}

/// Estatísticas de achievements
class AchievementStats {
  final int total;
  final int unlocked;
  final int rare;
  final int rareUnlocked;
  final double progress;

  const AchievementStats({
    required this.total,
    required this.unlocked,
    required this.rare,
    required this.rareUnlocked,
    required this.progress,
  });

  int get locked => total - unlocked;
  double get completionPercentage => progress * 100;
}

/// Notifier para achievements de um jogo específico
class GameAchievementsNotifier extends StateNotifier<GameAchievementsState> {
  GameAchievementsNotifier(this._steamGamesService)
    : super(const GameAchievementsState());

  final SteamGamesService _steamGamesService;

  /// Busca achievements de um jogo
  Future<void> loadGameAchievements(String appId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Buscar Steam ID do cache
      final userData = await CacheService.getUserData();
      final steamId = userData?['steamId'] as String?;

      if (steamId == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Steam ID não encontrado. Faça login novamente.',
        );
        return;
      }

      final achievements = await _steamGamesService.getCompleteGameAchievements(
        steamId,
        appId,
      );

      state = state.copyWith(achievements: achievements, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar achievements: $e',
      );
    }
  }

  /// Altera o filtro de achievements
  void setFilter(AchievementFilter filter) {
    state = state.copyWith(filter: filter);
  }

  /// Limpa o erro
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Recarrega os achievements
  Future<void> refresh(String appId) async {
    await loadGameAchievements(appId);
  }
}

/// Provider family para achievements de um jogo específico
final gameAchievementsNotifierProvider =
    StateNotifierProvider.family<
      GameAchievementsNotifier,
      GameAchievementsState,
      String
    >((ref, appId) {
      final steamGamesService = ref.watch(steamGamesServiceProvider);
      final notifier = GameAchievementsNotifier(steamGamesService);

      // Carregar achievements automaticamente
      Future.microtask(() => notifier.loadGameAchievements(appId));

      return notifier;
    });

/// Providers convenientes para acessar dados específicos
final gameAchievementsProvider =
    Provider.family<List<CompleteSteamAchievementModel>, String>((ref, appId) {
      return ref
          .watch(gameAchievementsNotifierProvider(appId))
          .filteredAchievements;
    });

final gameAchievementsStatsProvider = Provider.family<AchievementStats, String>(
  (ref, appId) {
    return ref.watch(gameAchievementsNotifierProvider(appId)).stats;
  },
);

final gameAchievementsLoadingProvider = Provider.family<bool, String>((
  ref,
  appId,
) {
  return ref.watch(gameAchievementsNotifierProvider(appId)).isLoading;
});

final gameAchievementsErrorProvider = Provider.family<String?, String>((
  ref,
  appId,
) {
  return ref.watch(gameAchievementsNotifierProvider(appId)).error;
});

final gameAchievementsFilterProvider =
    Provider.family<AchievementFilter, String>((ref, appId) {
      return ref.watch(gameAchievementsNotifierProvider(appId)).filter;
    });
