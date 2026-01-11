import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/gaming_platform.dart';
import '../../../../core/services/platform_connections_service.dart';

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

  /// Recarrega o estado das plataformas
  Future<void> refreshPlatforms() async {
    state = state.copyWith(isLoading: true);
    final platforms = await _getPlatformsData();
    final connectedCount = platforms.where((p) => p.isConnected).length;

    state = state.copyWith(
      platforms: platforms,
      isLoading: false,
      connectedCount: connectedCount,
    );
  }

  Future<List<GamingPlatform>> _getPlatformsData() async {
    // Verificar plataformas conectadas usando novo serviço
    final connectedPlatformIds =
        await PlatformConnectionsService.getConnectedPlatformIds();

    // Obter dados de conexões
    final steamConnection = await PlatformConnectionsService.getConnection(
      'steam',
    );
    final xboxConnection = await PlatformConnectionsService.getConnection(
      'xbox',
    );
    final epicConnection = await PlatformConnectionsService.getConnection(
      'epic',
    );

    return [
      GamingPlatform(
        id: 'steam',
        name: 'Steam',
        description: 'Games • Achievements • Friends',
        type: PlatformType.steam,
        status: connectedPlatformIds.contains('steam')
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
        primaryColor: const Color(0xFF171a21),
        backgroundColor: const Color(0xFF171a21),
        icon: Icons.sports_esports,
        features: ['Games', 'Achievements', 'Friends'],
        connectedAt: steamConnection?.connectedAt,
        connectedUsername: steamConnection?.username,
      ),
      GamingPlatform(
        id: 'xbox',
        name: 'Xbox',
        description: 'Games • Friends',
        type: PlatformType.xbox,
        status: connectedPlatformIds.contains('xbox')
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
        primaryColor: const Color(0xFF107C10),
        backgroundColor: const Color(0xFF107C10),
        icon: Icons.gamepad,
        logoText: 'X',
        features: ['Games', 'Friends'],
        connectedAt: xboxConnection?.connectedAt,
        connectedUsername: xboxConnection?.username,
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
        status: connectedPlatformIds.contains('epic_games')
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
        primaryColor: const Color(0xFF333333),
        backgroundColor: const Color(0xFF333333),
        icon: Icons.change_history,
        features: ['Games'],
        connectedAt: epicConnection?.connectedAt,
        connectedUsername: epicConnection?.username,
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

  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Conecta uma plataforma usando os serviços de integração
  Future<void> connectPlatform(String platformId, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      switch (platformId) {
        case 'steam':
          // await _connectSteam(context);
          break;
        default:
          throw Exception('Plataforma não suportada: $platformId');
      }

      // Atualizar estado das plataformas
      await refreshPlatforms();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao conectar plataforma: $e',
      );
    }
  }

  /// Desconecta uma plataforma removendo dados locais
  Future<void> disconnectPlatform(String platformId) async {
    try {
      state = state.copyWith(isLoading: true);

      // Remover conexão local
      await PlatformConnectionsService.removeConnection(platformId);

      // Atualizar estado das plataformas
      await refreshPlatforms();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao desconectar plataforma: $e',
      );
    }
  }
}
