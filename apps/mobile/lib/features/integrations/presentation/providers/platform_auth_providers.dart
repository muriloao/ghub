import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:ghub_mobile/core/auth/platform_auth_service.dart';
import 'package:ghub_mobile/core/auth/platform_manager.dart';
import 'package:ghub_mobile/features/auth/data/models/auth_result_model.dart';
import 'package:flutter/material.dart';

/// Provider para instância do Dio
final dioProvider = Provider<Dio>((ref) => Dio());

/// Provider para gerenciador de plataformas
final platformManagerProvider = Provider<PlatformManager>((ref) {
  final services = <PlatformAuthService>[ref.read(steamServiceProvider)];

  return PlatformManager(services);
});

/// Provider para informações das plataformas
final platformInfosProvider = Provider<List<PlatformInfo>>((ref) {
  final manager = ref.read(platformManagerProvider);
  return manager.getPlatformInfos();
});

/// Provider para plataformas configuradas
final configuredPlatformsProvider = Provider<List<PlatformAuthService>>((ref) {
  final manager = ref.read(platformManagerProvider);
  return manager.configuredServices;
});

/// Provider para status de autenticação das plataformas
final platformAuthStatusProvider = FutureProvider<Map<String, bool>>((
  ref,
) async {
  final manager = ref.read(platformManagerProvider);
  return manager.getAuthenticationStatus();
});

/// State notifier para gerenciar estado de autenticação
class PlatformAuthNotifier extends StateNotifier<PlatformAuthState> {
  final PlatformManager _platformManager;

  PlatformAuthNotifier(this._platformManager)
    : super(PlatformAuthState.initial());

  /// Autentica com uma plataforma
  Future<void> authenticateWithPlatform(
    String platformName,
    BuildContext context,
  ) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPlatform: platformName,
    );

    try {
      final result = await _platformManager.authenticateWithPlatform(
        platformName,
        context,
      );

      if (result != null) {
        state = state.copyWith(
          isLoading: false,
          authenticatedPlatforms: {
            ...state.authenticatedPlatforms,
            platformName: result,
          },
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Autenticação cancelada ou falhou',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Desconecta de uma plataforma
  Future<void> disconnectFromPlatform(String platformName) async {
    try {
      await _platformManager.disconnectFromPlatform(platformName);

      final updatedPlatforms = Map<String, AuthResultModel>.from(
        state.authenticatedPlatforms,
      );
      updatedPlatforms.remove(platformName);

      state = state.copyWith(
        authenticatedPlatforms: updatedPlatforms,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Desconecta de todas as plataformas
  Future<void> disconnectFromAllPlatforms() async {
    try {
      await _platformManager.disconnectFromAllPlatforms();

      state = state.copyWith(authenticatedPlatforms: {}, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Atualiza tokens de todas as plataformas
  Future<void> refreshAllTokens() async {
    state = state.copyWith(isLoading: true);

    try {
      await _platformManager.refreshAllTokens();
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Limpa erros
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Verifica se uma plataforma está autenticada
  bool isPlatformAuthenticated(String platformName) {
    return state.authenticatedPlatforms.containsKey(platformName);
  }

  /// Obtém resultado de autenticação de uma plataforma
  AuthResultModel? getPlatformAuthResult(String platformName) {
    return state.authenticatedPlatforms[platformName];
  }
}

/// Provider para o notifier de autenticação de plataformas
final platformAuthProvider =
    StateNotifierProvider<PlatformAuthNotifier, PlatformAuthState>((ref) {
      final manager = ref.read(platformManagerProvider);
      return PlatformAuthNotifier(manager);
    });

/// Estado da autenticação de plataformas
class PlatformAuthState {
  final bool isLoading;
  final String? error;
  final String? currentPlatform;
  final Map<String, AuthResultModel> authenticatedPlatforms;

  const PlatformAuthState({
    required this.isLoading,
    this.error,
    this.currentPlatform,
    required this.authenticatedPlatforms,
  });

  factory PlatformAuthState.initial() {
    return const PlatformAuthState(
      isLoading: false,
      authenticatedPlatforms: {},
    );
  }

  PlatformAuthState copyWith({
    bool? isLoading,
    String? error,
    String? currentPlatform,
    Map<String, AuthResultModel>? authenticatedPlatforms,
  }) {
    return PlatformAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPlatform: currentPlatform ?? this.currentPlatform,
      authenticatedPlatforms:
          authenticatedPlatforms ?? this.authenticatedPlatforms,
    );
  }

  /// Verifica se tem plataformas autenticadas
  bool get hasAuthenticatedPlatforms => authenticatedPlatforms.isNotEmpty;

  /// Lista de nomes de plataformas autenticadas
  List<String> get authenticatedPlatformNames =>
      authenticatedPlatforms.keys.toList();

  /// Número de plataformas autenticadas
  int get authenticatedPlatformCount => authenticatedPlatforms.length;
}
