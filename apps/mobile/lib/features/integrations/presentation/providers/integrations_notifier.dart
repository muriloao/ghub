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
      final platforms = await _platformsRepository.getAvailablePlatforms();
      final connectedCount = platforms.where((p) => p.isConnected).length;

      state = state.copyWith(
        platforms: platforms,
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
      final platforms = await _platformsRepository.getAvailablePlatforms();
      final connectedCount = platforms.where((p) => p.isConnected).length;

      state = state.copyWith(
        platforms: platforms,
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
}
