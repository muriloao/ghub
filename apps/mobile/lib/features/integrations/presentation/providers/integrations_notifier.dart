import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/gaming_platform.dart';
import '../../domain/repositories/platforms_repository.dart';
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
  final PlatformsRepository _platformsRepository;

  IntegrationsNotifier(this._platformsRepository) : super(_getInitialState()) {
    _initializePlatforms();
  }

  static IntegrationsState _getInitialState() {
    return const IntegrationsState(platforms: [], isLoading: true);
  }

  void _initializePlatforms() async {
    try {
      // Primeiro, carregar plataformas disponíveis da API
      final platforms = await _platformsRepository.getAvailablePlatforms();

      // Depois, verificar conexões salvas localmente
      final updatedPlatforms = <GamingPlatform>[];

      for (final platform in platforms) {
        try {
          // Verificar se existe conexão salva para esta plataforma
          final isConnected = await PlatformConnectionsService.isConnected(
            platform.id,
          );
          final connectionData = isConnected
              ? await PlatformConnectionsService.getConnection(platform.id)
              : null;

          // Atualizar plataforma com dados de conexão
          final updatedPlatform = platform.copyWith(
            status: isConnected
                ? ConnectionStatus.connected
                : ConnectionStatus.disconnected,
            connectedUsername: connectionData?.username,
            connectedAt: connectionData?.connectedAt != null
                ? DateTime.tryParse(connectionData!.connectedAt as String)
                : null,
          );

          updatedPlatforms.add(updatedPlatform);
        } catch (e) {
          // Em caso de erro, manter plataforma desconectada
          updatedPlatforms.add(platform);
        }
      }

      final connectedCount = updatedPlatforms
          .where((p) => p.isConnected)
          .length;

      state = state.copyWith(
        platforms: updatedPlatforms,
        isLoading: false,
        connectedCount: connectedCount,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load platforms: $e',
      );
    }
  }

  /// Recarrega o estado das plataformas
  Future<void> refreshPlatforms() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Carregar plataformas da API
      final platforms = await _platformsRepository.getAvailablePlatforms();

      // Recuperar estados de conexão salvos
      final updatedPlatforms = <GamingPlatform>[];

      for (final platform in platforms) {
        try {
          final isConnected = await PlatformConnectionsService.isConnected(
            platform.id,
          );
          final connectionData = isConnected
              ? await PlatformConnectionsService.getConnection(platform.id)
              : null;

          final updatedPlatform = platform.copyWith(
            status: isConnected
                ? ConnectionStatus.connected
                : ConnectionStatus.disconnected,
            connectedUsername: connectionData?.username,
            connectedAt: connectionData?.connectedAt != null
                ? DateTime.tryParse(connectionData!.connectedAt as String)
                : null,
          );

          updatedPlatforms.add(updatedPlatform);
        } catch (e) {
          updatedPlatforms.add(platform);
        }
      }

      final connectedCount = updatedPlatforms
          .where((p) => p.isConnected)
          .length;

      state = state.copyWith(
        platforms: updatedPlatforms,
        isLoading: false,
        connectedCount: connectedCount,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to refresh platforms: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Conecta uma plataforma usando os serviços de integração
  Future<void> connectPlatform(String platformId, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

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
      state = state.copyWith(isLoading: true, error: null);

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

  /// Sincroniza o estado das conexões com o storage local
  Future<void> syncConnectionStates() async {
    final platforms = state.platforms;
    final updatedPlatforms = <GamingPlatform>[];

    for (final platform in platforms) {
      try {
        final isConnected = await PlatformConnectionsService.isConnected(
          platform.id,
        );
        final connectionData = isConnected
            ? await PlatformConnectionsService.getConnection(platform.id)
            : null;

        final updatedPlatform = platform.copyWith(
          status: isConnected
              ? ConnectionStatus.connected
              : ConnectionStatus.disconnected,
          connectedUsername: connectionData?.username,
          connectedAt: connectionData?.connectedAt != null
              ? DateTime.tryParse(connectionData!.connectedAt as String)
              : null,
        );

        updatedPlatforms.add(updatedPlatform);
      } catch (e) {
        updatedPlatforms.add(platform);
      }
    }

    final connectedCount = updatedPlatforms.where((p) => p.isConnected).length;

    state = state.copyWith(
      platforms: updatedPlatforms,
      connectedCount: connectedCount,
    );
  }
}
