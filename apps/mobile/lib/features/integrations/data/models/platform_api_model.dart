import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/gaming_platform.dart';

part 'platform_api_model.freezed.dart';
part 'platform_api_model.g.dart';

@freezed
class PlatformColorScheme with _$PlatformColorScheme {
  const factory PlatformColorScheme({
    required String primary,
    required String secondary,
  }) = _PlatformColorScheme;

  factory PlatformColorScheme.fromJson(Map<String, Object?> json) =>
      _$PlatformColorSchemeFromJson(json);
}

@freezed
class PlatformEndpoints with _$PlatformEndpoints {
  const factory PlatformEndpoints({
    required String baseUrl,
    required String auth,
    required String userProfile,
    required String gameLibrary,
    required String achievements,
    String? friendsList,
    String? gameStats,
  }) = _PlatformEndpoints;

  factory PlatformEndpoints.fromJson(Map<String, Object?> json) =>
      _$PlatformEndpointsFromJson(json);
}

@freezed
class PlatformAuthConfig with _$PlatformAuthConfig {
  const factory PlatformAuthConfig({
    required String type,
    required bool clientIdRequired,
    required bool secretRequired,
    required String redirectUri,
    required List<String> scopes,
  }) = _PlatformAuthConfig;

  factory PlatformAuthConfig.fromJson(Map<String, Object?> json) =>
      _$PlatformAuthConfigFromJson(json);
}

@freezed
class PlatformFeatures with _$PlatformFeatures {
  const factory PlatformFeatures({
    required bool gameLibrary,
    required bool achievements,
    required bool friendsList,
    required bool gameStats,
    required bool screenshots,
    required bool gameTime,
  }) = _PlatformFeatures;

  factory PlatformFeatures.fromJson(Map<String, Object?> json) =>
      _$PlatformFeaturesFromJson(json);
}

@freezed
class PlatformApiModel with _$PlatformApiModel {
  const factory PlatformApiModel({
    required String id,
    required String name,
    required String displayName,
    required String description,
    required String logoUrl,
    required PlatformColorScheme colorScheme,
    required PlatformEndpoints endpoints,
    required PlatformAuthConfig authConfig,
    required PlatformFeatures features,
    required bool isEnabled,
    required bool comingSoon,
    required int priority,
  }) = _PlatformApiModel;

  factory PlatformApiModel.fromJson(Map<String, Object?> json) =>
      _$PlatformApiModelFromJson(json);
}

@freezed
class PlatformsListResponse with _$PlatformsListResponse {
  const factory PlatformsListResponse({
    required List<PlatformApiModel> platforms,
    required int totalCount,
    required String lastUpdated,
  }) = _PlatformsListResponse;

  factory PlatformsListResponse.fromJson(Map<String, Object?> json) =>
      _$PlatformsListResponseFromJson(json);
}

extension PlatformApiModelX on PlatformApiModel {
  /// Converts the API model to the domain GamingPlatform entity
  GamingPlatform toDomainEntity({
    ConnectionStatus status = ConnectionStatus.disconnected,
    DateTime? connectedAt,
    String? connectedUsername,
  }) {
    return GamingPlatform(
      id: id,
      name: displayName,
      description: description,
      type: _mapPlatformType(id),
      status: status,
      primaryColor: _parseColor(colorScheme.primary),
      backgroundColor: _parseColor(colorScheme.primary).withValues(alpha: 0.1),
      icon: _getIconForPlatform(id),
      logoText: _getLogoTextForPlatform(id),
      features: _mapFeaturesToList(features),
      connectedAt: connectedAt,
      connectedUsername: connectedUsername,
    );
  }

  PlatformType _mapPlatformType(String platformId) {
    switch (platformId.toLowerCase()) {
      case 'steam':
        return PlatformType.steam;
      case 'xbox':
      case 'xbox_live':
        return PlatformType.xbox;
      case 'playstation':
      case 'playstation_network':
        return PlatformType.playstation;
      case 'epic':
      case 'epic_games':
        return PlatformType.epicGames;
      case 'gog':
      case 'gog_galaxy':
        return PlatformType.gogGalaxy;
      case 'uplay':
        return PlatformType.uplay;
      case 'ea_play':
        return PlatformType.eaPlay;
      case 'origin':
        return PlatformType.origin;
      case 'battle_net':
        return PlatformType.battleNet;
      case 'amazon_games':
        return PlatformType.amazonGames;
      default:
        return PlatformType.steam; // fallback
    }
  }

  Color _parseColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF6C5CE7); // fallback color
    }
  }

  IconData _getIconForPlatform(String platformId) {
    switch (platformId.toLowerCase()) {
      case 'steam':
        return Icons.sports_esports;
      case 'xbox':
      case 'xbox_live':
        return Icons.gamepad;
      case 'playstation':
      case 'playstation_network':
        return Icons.sports_esports;
      case 'epic':
      case 'epic_games':
        return Icons.change_history;
      case 'gog':
      case 'gog_galaxy':
        return Icons.games;
      case 'uplay':
        return Icons.games;
      case 'ea_play':
        return Icons.sports_esports;
      case 'origin':
        return Icons.sports_esports;
      case 'battle_net':
        return Icons.shield;
      case 'amazon_games':
        return Icons.shopping_cart;
      default:
        return Icons.videogame_asset;
    }
  }

  String? _getLogoTextForPlatform(String platformId) {
    switch (platformId.toLowerCase()) {
      case 'xbox':
      case 'xbox_live':
        return 'X';
      case 'playstation':
      case 'playstation_network':
        return 'PS';
      case 'gog':
      case 'gog_galaxy':
        return 'GOG';
      case 'ea_play':
        return 'EA';
      default:
        return null;
    }
  }

  List<String> _mapFeaturesToList(PlatformFeatures features) {
    final List<String> featuresList = [];

    if (features.gameLibrary) featuresList.add('Games');
    if (features.achievements) featuresList.add('Achievements');
    if (features.friendsList) featuresList.add('Friends');
    if (features.gameStats) featuresList.add('Stats');
    if (features.screenshots) featuresList.add('Screenshots');
    if (features.gameTime) featuresList.add('Game Time');

    return featuresList;
  }
}
