import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../features/games/data/services/steam_games_service.dart';
import 'cache_service.dart';

/// Resultado da sincronização de uma plataforma
class SyncResult {
  final Platform platform;
  final bool success;
  final String? error;
  final int? gamesCount;
  final DateTime syncTime;

  const SyncResult({
    required this.platform,
    required this.success,
    this.error,
    this.gamesCount,
    required this.syncTime,
  });

  factory SyncResult.success(Platform platform, {int? gamesCount}) {
    return SyncResult(
      platform: platform,
      success: true,
      gamesCount: gamesCount,
      syncTime: DateTime.now(),
    );
  }

  factory SyncResult.error(Platform platform, String error) {
    return SyncResult(
      platform: platform,
      success: false,
      error: error,
      syncTime: DateTime.now(),
    );
  }
}

/// Estado de sincronização de plataformas
class PlatformSyncState {
  final Map<Platform, bool> syncing;
  final Map<Platform, SyncResult?> lastResults;
  final String? globalError;

  const PlatformSyncState({
    this.syncing = const {},
    this.lastResults = const {},
    this.globalError,
  });

  PlatformSyncState copyWith({
    Map<Platform, bool>? syncing,
    Map<Platform, SyncResult?>? lastResults,
    String? globalError,
  }) {
    return PlatformSyncState(
      syncing: syncing ?? this.syncing,
      lastResults: lastResults ?? this.lastResults,
      globalError: globalError,
    );
  }

  bool isSyncing(Platform platform) => syncing[platform] ?? false;
  SyncResult? getResult(Platform platform) => lastResults[platform];
  bool hasError(Platform platform) => lastResults[platform]?.success == false;
}

/// Serviço de sincronização de dados das plataformas
class PlatformSyncService {
  final SteamGamesService _steamService;

  PlatformSyncService(this._steamService);

  /// Sincroniza dados do Steam
  Future<SyncResult> syncSteam({String? steamId}) async {
    try {
      // Buscar Steam ID do cache se não fornecido
      if (steamId == null) {
        final cachedUser = await CacheService.getCachedUserData();
        steamId = cachedUser?.steamId;

        if (steamId == null) {
          return SyncResult.error(Platform.steam, 'Steam ID não encontrado');
        }
      }

      // Buscar dados do usuário Steam (perfil básico)
      Map<String, dynamic>? steamUserData;
      try {
        // Aqui você pode implementar busca de perfil Steam se necessário
        steamUserData = {
          'steamId': steamId,
          'lastUpdate': DateTime.now().millisecondsSinceEpoch,
        };
      } catch (e) {
        // Perfil não é crítico, continuar com os jogos
      }

      // Buscar jogos do usuário
      final games = await _steamService.getUserGames(steamId);

      // Salvar no cache
      await PlatformCacheExtension.cacheSteamData(
        userData: steamUserData,
        games: games,
      );

      return SyncResult.success(Platform.steam, gamesCount: games.length);
    } catch (e) {
      return SyncResult.error(
        Platform.steam,
        'Erro na sincronização Steam: $e',
      );
    }
  }

  /// Sincroniza uma plataforma específica
  Future<SyncResult> syncPlatform(Platform platform) async {
    switch (platform) {
      case Platform.steam:
        return syncSteam();
    }
  }

  /// Sincroniza todas as plataformas disponíveis
  Future<List<SyncResult>> syncAllPlatforms({bool onlyConnected = true}) async {
    final results = <SyncResult>[];

    // Verificar quais plataformas estão conectadas
    final cachedUser = await CacheService.getCachedUserData();

    // Steam
    if (!onlyConnected || cachedUser?.steamId != null) {
      results.add(await syncSteam());
    }

    return results;
  }

  /// Verifica se uma sincronização é necessária
  Future<bool> shouldSync(
    Platform platform, {
    Duration maxAge = const Duration(hours: 6),
  }) async {
    final isValid = await PlatformCacheExtension.isPlatformCacheValid(
      platform,
      maxAge: maxAge,
    );
    return !isValid;
  }

  /// Sincroniza apenas se necessário
  Future<SyncResult?> syncIfNeeded(Platform platform) async {
    final shouldSyncNow = await shouldSync(platform);
    if (shouldSyncNow) {
      return syncPlatform(platform);
    }
    return null; // Não precisava sincronizar
  }

  /// Força a sincronização mesmo com cache válido
  Future<SyncResult> forceSync(Platform platform) async {
    // Limpar cache antes de sincronizar
    await PlatformCacheExtension.clearPlatformCache(platform);
    return syncPlatform(platform);
  }
}

/// Provider do serviço de sincronização
final platformSyncServiceProvider = Provider<PlatformSyncService>((ref) {
  final dio = Dio();
  final steamService = SteamGamesService(dio);
  return PlatformSyncService(steamService);
});

/// Notifier para o estado de sincronização
class PlatformSyncNotifier extends StateNotifier<PlatformSyncState> {
  final PlatformSyncService _syncService;

  PlatformSyncNotifier(this._syncService) : super(const PlatformSyncState());

  /// Sincroniza uma plataforma específica
  Future<void> syncPlatform(Platform platform) async {
    // Marcar como sincronizando
    state = state.copyWith(
      syncing: {...state.syncing, platform: true},
      globalError: null,
    );

    try {
      // Executar sincronização
      final result = await _syncService.syncPlatform(platform);

      // Atualizar estado com resultado
      state = state.copyWith(
        syncing: {...state.syncing, platform: false},
        lastResults: {...state.lastResults, platform: result},
      );
    } catch (e) {
      // Marcar erro
      final errorResult = SyncResult.error(platform, e.toString());
      state = state.copyWith(
        syncing: {...state.syncing, platform: false},
        lastResults: {...state.lastResults, platform: errorResult},
        globalError: e.toString(),
      );
    }
  }

  /// Força sincronização de uma plataforma
  Future<void> forceSync(Platform platform) async {
    state = state.copyWith(
      syncing: {...state.syncing, platform: true},
      globalError: null,
    );

    try {
      final result = await _syncService.forceSync(platform);
      state = state.copyWith(
        syncing: {...state.syncing, platform: false},
        lastResults: {...state.lastResults, platform: result},
      );
    } catch (e) {
      final errorResult = SyncResult.error(platform, e.toString());
      state = state.copyWith(
        syncing: {...state.syncing, platform: false},
        lastResults: {...state.lastResults, platform: errorResult},
        globalError: e.toString(),
      );
    }
  }

  /// Sincroniza todas as plataformas
  Future<void> syncAllPlatforms() async {
    final platforms = [Platform.steam];

    // Marcar todas como sincronizando
    final syncingState = <Platform, bool>{};
    for (final platform in platforms) {
      syncingState[platform] = true;
    }
    state = state.copyWith(syncing: syncingState, globalError: null);

    // Sincronizar em paralelo
    final results = await _syncService.syncAllPlatforms();

    // Atualizar resultados
    final newResults = <Platform, SyncResult>{};
    final newSyncing = <Platform, bool>{};

    for (final result in results) {
      newResults[result.platform] = result;
      newSyncing[result.platform] = false;
    }

    state = state.copyWith(
      syncing: {...state.syncing, ...newSyncing},
      lastResults: {...state.lastResults, ...newResults},
    );
  }

  /// Limpa errors
  void clearError() {
    state = state.copyWith(globalError: null);
  }

  /// Limpa resultado de uma plataforma
  void clearResult(Platform platform) {
    final newResults = {...state.lastResults};
    newResults.remove(platform);
    state = state.copyWith(lastResults: newResults);
  }
}

/// Provider do notifier de sincronização
final platformSyncNotifierProvider =
    StateNotifierProvider<PlatformSyncNotifier, PlatformSyncState>((ref) {
      final syncService = ref.watch(platformSyncServiceProvider);
      return PlatformSyncNotifier(syncService);
    });

/// Providers para estados específicos
final isSyncingProvider = Provider.family<bool, Platform>((ref, platform) {
  final state = ref.watch(platformSyncNotifierProvider);
  return state.isSyncing(platform);
});

final syncResultProvider = Provider.family<SyncResult?, Platform>((
  ref,
  platform,
) {
  final state = ref.watch(platformSyncNotifierProvider);
  return state.getResult(platform);
});

final hasErrorProvider = Provider.family<bool, Platform>((ref, platform) {
  final state = ref.watch(platformSyncNotifierProvider);
  return state.hasError(platform);
});
