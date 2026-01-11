import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/gaming_platform.dart';
import '../../domain/repositories/platforms_repository.dart';
import '../services/platforms_api_service.dart';
import '../models/platform_api_model.dart';
import '../../../../core/services/platform_connections_service.dart';

class PlatformsRepositoryImpl implements PlatformsRepository {
  final PlatformsApiService _apiService;

  PlatformsRepositoryImpl(this._apiService);

  @override
  Future<List<GamingPlatform>> getAvailablePlatforms() async {
    final response = await _apiService.getAvailablePlatforms();
    final connectedPlatformIds =
        (await PlatformConnectionsService.getConnectedPlatformIds()).toList();

    return await _mapToGamingPlatforms(
      response.platforms,
      connectedPlatformIds,
    );
  }

  @override
  Future<List<GamingPlatform>> getEnabledPlatforms() async {
    final response = await _apiService.getEnabledPlatforms();
    final connectedPlatformIds =
        (await PlatformConnectionsService.getConnectedPlatformIds()).toList();

    return await _mapToGamingPlatforms(
      response.platforms,
      connectedPlatformIds,
    );
  }

  @override
  Future<List<GamingPlatform>> getAllPlatforms() async {
    final response = await _apiService.getAllPlatforms();
    final connectedPlatformIds =
        (await PlatformConnectionsService.getConnectedPlatformIds()).toList();

    return await _mapToGamingPlatforms(
      response.platforms,
      connectedPlatformIds,
    );
  }

  @override
  Future<GamingPlatform?> getPlatformById(String id) async {
    try {
      final platformModel = await _apiService.getPlatformById(id);
      final connectedPlatformIds =
          (await PlatformConnectionsService.getConnectedPlatformIds()).toList();
      final connection = await PlatformConnectionsService.getConnection(id);

      final status = connectedPlatformIds.contains(id)
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected;

      return platformModel.toDomainEntity(
        status: status,
        connectedAt: connection?.connectedAt,
        connectedUsername: connection?.username,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<GamingPlatform>> _mapToGamingPlatforms(
    List<PlatformApiModel> platforms,
    List<String> connectedPlatformIds,
  ) async {
    final List<GamingPlatform> result = [];

    for (final platform in platforms) {
      final connection = await PlatformConnectionsService.getConnection(
        platform.id,
      );
      final status = connectedPlatformIds.contains(platform.id)
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected;

      result.add(
        platform.toDomainEntity(
          status: status,
          connectedAt: connection?.connectedAt,
          connectedUsername: connection?.username,
        ),
      );
    }

    // Sort by priority (as returned by API)
    result.sort((a, b) {
      final platformA = platforms.firstWhere((p) => p.id == a.id);
      final platformB = platforms.firstWhere((p) => p.id == b.id);
      return platformA.priority.compareTo(platformB.priority);
    });

    return result;
  }
}

// Riverpod provider
final platformsRepositoryProvider = Provider<PlatformsRepository>((ref) {
  final apiService = ref.watch(platformsApiServiceProvider);
  return PlatformsRepositoryImpl(apiService);
});
