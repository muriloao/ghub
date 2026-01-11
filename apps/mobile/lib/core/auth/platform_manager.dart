import 'package:flutter/material.dart';
import '../../../core/auth/platform_auth_service.dart';
import '../../../features/auth/data/models/auth_result_model.dart';

/// Gerenciador unificado para todas as plataformas de jogos
class PlatformManager {
  final List<PlatformAuthService> _services;

  PlatformManager(this._services);

  /// Lista de todos os serviços de plataforma disponíveis
  List<PlatformAuthService> get availableServices => _services;

  /// Busca serviço por nome da plataforma
  PlatformAuthService? getServiceByName(String platformName) {
    try {
      return _services.firstWhere(
        (service) =>
            service.platformName.toLowerCase() == platformName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Lista apenas serviços que estão configurados corretamente
  List<PlatformAuthService> get configuredServices {
    return _services
        .where((service) => service.validateConfiguration())
        .toList();
  }

  /// Lista serviços não configurados
  List<PlatformAuthService> get unconfiguredServices {
    return _services
        .where((service) => !service.validateConfiguration())
        .toList();
  }

  /// Autentica com uma plataforma específica
  Future<AuthResultModel?> authenticateWithPlatform(
    String platformName,
    BuildContext context,
  ) async {
    final service = getServiceByName(platformName);
    if (service == null) {
      throw Exception('Plataforma $platformName não encontrada');
    }

    return service.authenticate();
  }

  /// Desconecta de uma plataforma específica
  Future<void> disconnectFromPlatform(String platformName) async {
    final service = getServiceByName(platformName);
    if (service == null) {
      throw Exception('Plataforma $platformName não encontrada');
    }

    await service.disconnect();
  }

  /// Verifica status de autenticação de todas as plataformas
  Future<Map<String, bool>> getAuthenticationStatus() async {
    final status = <String, bool>{};

    for (final service in _services) {
      try {
        status[service.platformName] = await service.isAuthenticated();
      } catch (e) {
        status[service.platformName] = false;
      }
    }

    return status;
  }

  /// Desconecta de todas as plataformas
  Future<void> disconnectFromAllPlatforms() async {
    final futures = _services.map((service) => service.disconnect());
    await Future.wait(futures);
  }

  /// Atualiza tokens de todas as plataformas autenticadas
  Future<Map<String, bool>> refreshAllTokens() async {
    final results = <String, bool>{};

    for (final service in _services) {
      try {
        final isAuthenticated = await service.isAuthenticated();
        if (isAuthenticated) {
          results[service.platformName] = await service.refreshToken();
        }
      } catch (e) {
        results[service.platformName] = false;
      }
    }

    return results;
  }

  /// Obtém informações resumidas de todas as plataformas
  List<PlatformInfo> getPlatformInfos() {
    return _services
        .map(
          (service) => PlatformInfo(
            name: service.platformName,
            icon: service.platformIcon,
            color: service.platformColor,
            isConfigured: service.validateConfiguration(),
          ),
        )
        .toList();
  }
}

/// Informações básicas de uma plataforma
class PlatformInfo {
  final String name;
  final String icon;
  final int color;
  final bool isConfigured;

  const PlatformInfo({
    required this.name,
    required this.icon,
    required this.color,
    required this.isConfigured,
  });
}

/// Estados possíveis de uma plataforma
enum PlatformStatus { notConfigured, configured, authenticated, error }

/// Status detalhado de uma plataforma
class DetailedPlatformStatus {
  final PlatformInfo info;
  final PlatformStatus status;
  final String? errorMessage;
  final DateTime? lastAuthenticated;

  const DetailedPlatformStatus({
    required this.info,
    required this.status,
    this.errorMessage,
    this.lastAuthenticated,
  });
}
