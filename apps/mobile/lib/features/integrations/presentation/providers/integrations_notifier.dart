import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/gaming_platform.dart';
import '../../data/services/xbox_live_service.dart';
import '../../../../core/services/integrations_cache_service.dart';
import '../../../../core/error/exceptions.dart';

class IntegrationsState {
  final List<GamingPlatform> platforms;
  final bool isLoading;
  final String? error;
  final int connectedCount;

  const IntegrationsState({
    required this.platforms,
    this.isLoading = false,
    this.error,
    this.connectedCount = 0,
  });

  IntegrationsState copyWith({
    List<GamingPlatform>? platforms,
    bool? isLoading,
    String? error,
    int? connectedCount,
  }) {
    return IntegrationsState(
      platforms: platforms ?? this.platforms,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      connectedCount: connectedCount ?? this.connectedCount,
    );
  }

  double get connectionProgress {
    if (platforms.isEmpty) return 0.0;
    return connectedCount / platforms.length;
  }

  List<GamingPlatform> get connectedPlatforms =>
      platforms.where((p) => p.isConnected).toList();
  List<GamingPlatform> get disconnectedPlatforms =>
      platforms.where((p) => !p.isConnected).toList();
}

class IntegrationsNotifier extends StateNotifier<IntegrationsState> {
  IntegrationsNotifier() : super(_getInitialState()) {
    _initializePlatforms();
  }

  static IntegrationsState _getInitialState() {
    return const IntegrationsState(platforms: [], isLoading: true);
  }

  void _initializePlatforms() async {
    final platforms = await _getPlatformsData();
    final connectedCount = platforms.where((p) => p.isConnected).length;

    state = state.copyWith(
      platforms: platforms,
      isLoading: false,
      connectedCount: connectedCount,
    );
  }

  Future<List<GamingPlatform>> _getPlatformsData() async {
    // Verificar plataformas conectadas no cache
    final connectedPlatforms =
        await IntegrationsCacheService.getConnectedPlatforms();

    return [
      GamingPlatform(
        id: 'steam',
        name: 'Steam',
        description: 'Games • Achievements • Friends',
        type: PlatformType.steam,
        status: connectedPlatforms.containsKey('steam')
            ? ConnectionStatus.connected
            : ConnectionStatus.connected, // Sempre conectado por autenticação
        primaryColor: const Color(0xFF171a21),
        backgroundColor: const Color(0xFF171a21),
        icon: Icons.sports_esports,
        features: ['Games', 'Achievements', 'Friends'],
        connectedAt:
            connectedPlatforms['steam']?.connectedAt ??
            DateTime.now().subtract(const Duration(days: 7)),
        connectedUsername: connectedPlatforms['steam']?.username ?? 'SteamUser',
      ),
      GamingPlatform(
        id: 'xbox',
        name: 'Xbox',
        description: 'Games • Friends',
        type: PlatformType.xbox,
        status: connectedPlatforms.containsKey('xbox')
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
        primaryColor: const Color(0xFF107C10),
        backgroundColor: const Color(0xFF107C10),
        icon: Icons.gamepad,
        logoText: 'X',
        features: ['Games', 'Friends'],
        connectedAt: connectedPlatforms['xbox']?.connectedAt,
        connectedUsername: connectedPlatforms['xbox']?.username,
      ),
      GamingPlatform(
        id: 'playstation',
        name: 'PlayStation',
        description: 'Games • Trophies',
        type: PlatformType.playstation,
        status: ConnectionStatus.disconnected,
        primaryColor: const Color(0xFF003791),
        backgroundColor: const Color(0xFF003791),
        icon: Icons.sports_esports,
        logoText: 'PS',
        features: ['Games', 'Trophies'],
      ),
      GamingPlatform(
        id: 'epic_games',
        name: 'Epic Games',
        description: 'Games Only',
        type: PlatformType.epicGames,
        status: ConnectionStatus.disconnected,
        primaryColor: const Color(0xFF333333),
        backgroundColor: const Color(0xFF333333),
        icon: Icons.change_history,
        features: ['Games'],
      ),
      GamingPlatform(
        id: 'gog_galaxy',
        name: 'GOG Galaxy',
        description: 'Games • Friends',
        type: PlatformType.gogGalaxy,
        status: ConnectionStatus.disconnected,
        primaryColor: const Color(0xFF86328A),
        backgroundColor: const Color(0xFF86328A),
        icon: Icons.games,
        logoText: 'GOG',
        features: ['Games', 'Friends'],
      ),
      GamingPlatform(
        id: 'uplay',
        name: 'Uplay',
        description: 'Games • Achievements',
        type: PlatformType.uplay,
        status: ConnectionStatus.disconnected,
        primaryColor: const Color(0xFF0084C7),
        backgroundColor: const Color(0xFF0084C7),
        icon: Icons.games,
        features: ['Games', 'Achievements'],
      ),
      GamingPlatform(
        id: 'ea_play',
        name: 'EA Play',
        description: 'Games Only',
        type: PlatformType.eaPlay,
        status: ConnectionStatus.disconnected,
        primaryColor: const Color(0xFFFF6600),
        backgroundColor: const Color(0xFFFF6600),
        icon: Icons.sports_esports,
        logoText: 'EA',
        features: ['Games'],
      ),
      GamingPlatform(
        id: 'amazon_games',
        name: 'Amazon Games',
        description: 'Games • Prime Gaming',
        type: PlatformType.amazonGames,
        status: ConnectionStatus.disconnected,
        primaryColor: const Color(0xFFFF9900),
        backgroundColor: const Color(0xFFFF9900),
        icon: Icons.shopping_cart,
        features: ['Games', 'Prime Gaming'],
      ),
    ];
  }

  Future<void> connectPlatform(
    String platformId, [
    BuildContext? context,
  ]) async {
    final platformIndex = state.platforms.indexWhere((p) => p.id == platformId);
    if (platformIndex == -1) return;

    // Update platform to connecting state
    final updatedPlatforms = List<GamingPlatform>.from(state.platforms);
    updatedPlatforms[platformIndex] = updatedPlatforms[platformIndex].copyWith(
      status: ConnectionStatus.connecting,
    );

    state = state.copyWith(platforms: updatedPlatforms);

    try {
      if (platformId == 'xbox') {
        // Conexão real com Xbox Live
        await _connectXboxLive(context);
      } else {
        // Simulate API call for other platforms
        await Future.delayed(const Duration(seconds: 2));

        // Update to connected state
        updatedPlatforms[platformIndex] = updatedPlatforms[platformIndex]
            .copyWith(
              status: ConnectionStatus.connected,
              connectedAt: DateTime.now(),
              connectedUsername: '${updatedPlatforms[platformIndex].name}User',
            );
      }

      // Refresh platforms from cache
      await refreshPlatforms();
    } catch (e) {
      // Para Xbox, é esperado que lance AuthenticationException
      if (e is AuthenticationException && platformId == 'xbox') {
        // Reset para disconnected apenas se houve erro real
        updatedPlatforms[platformIndex] = updatedPlatforms[platformIndex]
            .copyWith(status: ConnectionStatus.disconnected);

        state = state.copyWith(platforms: updatedPlatforms);
        return; // Xbox authentication flow iniciado com sucesso
      }

      // Reset to disconnected on error
      updatedPlatforms[platformIndex] = updatedPlatforms[platformIndex]
          .copyWith(status: ConnectionStatus.disconnected);

      state = state.copyWith(
        platforms: updatedPlatforms,
        error:
            'Failed to connect to ${updatedPlatforms[platformIndex].name}: $e',
      );
    }
  }

  Future<void> _connectXboxLive(BuildContext? context) async {
    if (context == null) {
      throw const AuthenticationException(
        message: 'Context required for Xbox authentication',
      );
    }

    // Iniciar fluxo de autenticação Xbox Live
    final xboxService = XboxLiveService(Dio());
    await xboxService.authenticateWithXbox(context);
  }

  Future<void> disconnectPlatform(String platformId) async {
    final platformIndex = state.platforms.indexWhere((p) => p.id == platformId);
    if (platformIndex == -1) return;

    try {
      // Remove from cache
      await IntegrationsCacheService.removePlatformConnection(platformId);

      // Update local state
      final updatedPlatforms = List<GamingPlatform>.from(state.platforms);
      updatedPlatforms[platformIndex] = updatedPlatforms[platformIndex]
          .copyWith(
            status: ConnectionStatus.disconnected,
            connectedAt: null,
            connectedUsername: null,
          );

      final connectedCount = updatedPlatforms
          .where((p) => p.isConnected)
          .length;

      state = state.copyWith(
        platforms: updatedPlatforms,
        connectedCount: connectedCount,
      );
    } catch (e) {
      state = state.copyWith(
        error:
            'Failed to disconnect from ${state.platforms[platformIndex].name}: $e',
      );
    }
  }

  /// Atualiza as plataformas a partir do cache
  Future<void> refreshPlatforms() async {
    final platforms = await _getPlatformsData();
    final connectedCount = platforms.where((p) => p.isConnected).length;

    state = state.copyWith(
      platforms: platforms,
      connectedCount: connectedCount,
      isLoading: false,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
