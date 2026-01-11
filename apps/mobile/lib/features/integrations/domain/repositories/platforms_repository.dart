import '../../domain/entities/gaming_platform.dart';

abstract class PlatformsRepository {
  /// Gets all available platforms (enabled + coming soon)
  Future<List<GamingPlatform>> getAvailablePlatforms();

  /// Gets only enabled platforms
  Future<List<GamingPlatform>> getEnabledPlatforms();

  /// Gets all platforms
  Future<List<GamingPlatform>> getAllPlatforms();

  /// Gets a specific platform by ID
  Future<GamingPlatform?> getPlatformById(String id);
}
