import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/services/cache_service.dart';
import '../../../core/services/platform_sync_service.dart';
import '../data/services/steam_games_service.dart';
import '../data/models/steam_game_model.dart';
import '../../integrations/data/services/xbox_live_service.dart';

/// Estado dos jogos de uma plataforma
class PlatformGamesState {
  final List<dynamic> games;
  final bool isLoading;
  final String? error;
  final DateTime? lastSync;
  final Platform platform;

  const PlatformGamesState({
    this.games = const [],
    this.isLoading = false,
    this.error,
    this.lastSync,
    required this.platform,
  });

  PlatformGamesState copyWith({
    List<dynamic>? games,
    bool? isLoading,
    String? error,
    DateTime? lastSync,
  }) {
    return PlatformGamesState(
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastSync: lastSync ?? this.lastSync,
      platform: platform,
    );
  }
}

/// Notifier para jogos Steam
class SteamGamesNotifier extends StateNotifier<PlatformGamesState> {
  final SteamGamesService _steamService;
  final PlatformSyncService _syncService;

  SteamGamesNotifier(this._steamService, this._syncService)
    : super(const PlatformGamesState(platform: Platform.steam)) {
    loadGames();
  }

  /// Carrega jogos do cache ou API
  Future<void> loadGames({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Buscar Steam ID do cache
      final cachedUser = await CacheService.getCachedUserData();
      final steamId = cachedUser?.steamId;

      if (steamId == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Steam ID não encontrado. Faça login no Steam primeiro.',
        );
        return;
      }

      // Verificar se precisa sincronizar
      if (forceRefresh || await _syncService.shouldSync(Platform.steam)) {
        // Sincronizar dados
        await _syncService.syncPlatform(Platform.steam);
      }

      // Buscar dados do cache
      final cache = await PlatformCacheExtension.getSteamCache();
      if (cache?.gamesData != null) {
        final games = cache!.gamesData!
            .map((json) => SteamGameModel.fromJson(json))
            .toList();

        state = state.copyWith(
          games: games,
          isLoading: false,
          lastSync: cache.lastSync,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Nenhum jogo encontrado',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar jogos Steam: $e',
      );
    }
  }

  /// Força atualização dos dados
  Future<void> refresh() async {
    await loadGames(forceRefresh: true);
  }
}

/// Notifier para jogos Xbox
class XboxGamesNotifier extends StateNotifier<PlatformGamesState> {
  final XboxLiveService _xboxService;
  final PlatformSyncService _syncService;

  XboxGamesNotifier(this._xboxService, this._syncService)
    : super(const PlatformGamesState(platform: Platform.xbox)) {
    loadGames();
  }

  /// Carrega jogos do cache ou API
  Future<void> loadGames({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Buscar token do cache
      final cachedUser = await CacheService.getCachedUserData();
      final accessToken = cachedUser?.authToken;

      if (accessToken == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Token Xbox não encontrado. Faça login no Xbox primeiro.',
        );
        return;
      }

      // Verificar se precisa sincronizar
      if (forceRefresh || await _syncService.shouldSync(Platform.xbox)) {
        // Sincronizar dados
        await _syncService.syncPlatform(Platform.xbox);
      }

      // Buscar dados do cache
      final cache = await PlatformCacheExtension.getXboxCache();
      if (cache?.gamesData != null) {
        final games = cache!.gamesData!
            .map((json) => XboxGame.fromJson(json))
            .toList();

        state = state.copyWith(
          games: games,
          isLoading: false,
          lastSync: cache.lastSync,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Nenhum jogo encontrado',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar jogos Xbox: $e',
      );
    }
  }

  /// Força atualização dos dados
  Future<void> refresh() async {
    await loadGames(forceRefresh: true);
  }
}

/// Provider do serviço Steam
final steamGamesServiceProvider = Provider<SteamGamesService>((ref) {
  final dio = Dio();
  return SteamGamesService(dio);
});

/// Provider do serviço Xbox
final xboxGamesServiceProvider = Provider<XboxLiveService>((ref) {
  final dio = Dio();
  return XboxLiveService(dio);
});

/// Provider dos jogos Steam
final steamGamesNotifierProvider =
    StateNotifierProvider<SteamGamesNotifier, PlatformGamesState>((ref) {
      final steamService = ref.watch(steamGamesServiceProvider);
      final syncService = ref.watch(platformSyncServiceProvider);
      return SteamGamesNotifier(steamService, syncService);
    });

/// Provider dos jogos Xbox
final xboxGamesNotifierProvider =
    StateNotifierProvider<XboxGamesNotifier, PlatformGamesState>((ref) {
      final xboxService = ref.watch(xboxGamesServiceProvider);
      final syncService = ref.watch(platformSyncServiceProvider);
      return XboxGamesNotifier(xboxService, syncService);
    });

/// Providers convenientes para UI
final steamGamesProvider = Provider<List<SteamGameModel>>((ref) {
  final state = ref.watch(steamGamesNotifierProvider);
  return state.games.cast<SteamGameModel>();
});

final xboxGamesProvider = Provider<List<XboxGame>>((ref) {
  final state = ref.watch(xboxGamesNotifierProvider);
  return state.games.cast<XboxGame>();
});

final isSteamGamesLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(steamGamesNotifierProvider);
  return state.isLoading;
});

final isXboxGamesLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(xboxGamesNotifierProvider);
  return state.isLoading;
});

final steamGamesErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(steamGamesNotifierProvider);
  return state.error;
});

final xboxGamesErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(xboxGamesNotifierProvider);
  return state.error;
});

/// Provider para todos os jogos de todas as plataformas
final allGamesProvider = Provider<List<dynamic>>((ref) {
  final steamGames = ref.watch(steamGamesProvider);
  final xboxGames = ref.watch(xboxGamesProvider);

  return [...steamGames, ...xboxGames];
});

/// Provider para contagem total de jogos
final totalGamesCountProvider = Provider<int>((ref) {
  final allGames = ref.watch(allGamesProvider);
  return allGames.length;
});

/// Provider para estatísticas de cache
final cacheStatsProvider = FutureProvider<Map<Platform, DateTime?>>((
  ref,
) async {
  final caches = await PlatformCacheExtension.getAllPlatformCache();

  return {for (final entry in caches.entries) entry.key: entry.value?.lastSync};
});
