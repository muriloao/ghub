import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/features/onboarding/domain/entities/gaming_platform.dart';

void main() {
  group('GamingPlatform Entity', () {
    test('should create GamingPlatform with required fields', () {
      // arrange & act
      const platform = GamingPlatform(
        type: PlatformType.steam,
        isConnected: false,
      );

      // assert
      expect(platform.type, PlatformType.steam);
      expect(platform.isConnected, false);
      expect(platform.userId, null);
      expect(platform.userName, null);
      expect(platform.avatarUrl, null);
      expect(platform.gameCount, 0);
    });

    test('should create GamingPlatform from JSON correctly', () {
      // arrange
      final json = {
        'type': 'steam',
        'is_connected': true,
        'user_id': 'steam-user-123',
        'user_name': 'SteamUser',
        'avatar_url': 'https://example.com/avatar.jpg',
        'game_count': 150,
        'last_sync': '2024-01-01T00:00:00Z',
        'connection_error': null,
      };

      // act
      final platform = GamingPlatform.fromJson(json);

      // assert
      expect(platform.type, PlatformType.steam);
      expect(platform.isConnected, true);
      expect(platform.userId, 'steam-user-123');
      expect(platform.userName, 'SteamUser');
      expect(platform.avatarUrl, 'https://example.com/avatar.jpg');
      expect(platform.gameCount, 150);
      expect(platform.lastSync, DateTime.parse('2024-01-01T00:00:00Z'));
      expect(platform.connectionError, null);
    });

    test('should handle JSON with missing optional fields', () {
      // arrange
      final json = {
        'type': 'steam',
        'is_connected': false,
      };

      // act
      final platform = GamingPlatform.fromJson(json);

      // assert
      expect(platform.type, PlatformType.steam);
      expect(platform.isConnected, false);
      expect(platform.userId, null);
      expect(platform.userName, null);
      expect(platform.avatarUrl, null);
      expect(platform.gameCount, 0);
      expect(platform.lastSync, null);
      expect(platform.connectionError, null);
    });

    test('should convert GamingPlatform to JSON correctly', () {
      // arrange
      final platform = GamingPlatform(
        type: PlatformType.xbox,
        isConnected: true,
        userId: 'xbox-user-456',
        userName: 'XboxGamer',
        avatarUrl: 'https://example.com/xbox-avatar.jpg',
        gameCount: 75,
        lastSync: DateTime.parse('2024-01-01T00:00:00Z'),
        connectionError: null,
      );

      // act
      final json = platform.toJson();

      // assert
      expect(json['type'], 'xbox');
      expect(json['is_connected'], true);
      expect(json['user_id'], 'xbox-user-456');
      expect(json['user_name'], 'XboxGamer');
      expect(json['avatar_url'], 'https://example.com/xbox-avatar.jpg');
      expect(json['game_count'], 75);
      expect(json['last_sync'], '2024-01-01T00:00:00.000Z');
      expect(json['connection_error'], null);
    });

    test('should support equality comparison', () {
      // arrange
      const platform1 = GamingPlatform(
        type: PlatformType.steam,
        isConnected: true,
        userId: 'user-123',
      );
      const platform2 = GamingPlatform(
        type: PlatformType.steam,
        isConnected: true,
        userId: 'user-123',
      );
      const differentPlatform = GamingPlatform(
        type: PlatformType.xbox,
        isConnected: true,
        userId: 'user-456',
      );

      // assert
      expect(platform1, equals(platform2));
      expect(platform1, isNot(equals(differentPlatform)));
    });

    test('should create copy with updated fields', () {
      // arrange
      const originalPlatform = GamingPlatform(
        type: PlatformType.steam,
        isConnected: false,
        gameCount: 0,
      );

      // act
      final updatedPlatform = originalPlatform.copyWith(
        isConnected: true,
        userId: 'steam-user-123',
        userName: 'SteamUser',
        gameCount: 100,
      );

      // assert
      expect(updatedPlatform.isConnected, true);
      expect(updatedPlatform.userId, 'steam-user-123');
      expect(updatedPlatform.userName, 'SteamUser');
      expect(updatedPlatform.gameCount, 100);
      expect(updatedPlatform.type, originalPlatform.type);
    });
  });

  group('PlatformType Extension', () {
    test('should return correct names for all platform types', () {
      expect(PlatformType.steam.name, 'Steam');
      expect(PlatformType.xbox.name, 'Xbox');
      expect(PlatformType.playstation.name, 'PlayStation');
      expect(PlatformType.epicGames.name, 'Epic Games');
      expect(PlatformType.gog.name, 'GOG Galaxy');
      expect(PlatformType.nintendo.name, 'Nintendo');
      expect(PlatformType.origin.name, 'Origin');
      expect(PlatformType.uplay.name, 'Uplay');
    });

    test('should return correct descriptions for all platform types', () {
      expect(PlatformType.steam.description, 'Games • Achievements • Friends');
      expect(PlatformType.xbox.description, 'Games • Friends');
      expect(PlatformType.playstation.description, 'Games • Trophies');
      expect(PlatformType.epicGames.description, 'Games Only');
      expect(PlatformType.gog.description, 'Games • Friends');
      expect(PlatformType.nintendo.description, 'Games • Friends');
      expect(PlatformType.origin.description, 'Games Only');
      expect(PlatformType.uplay.description, 'Games Only');
    });

    test('should return correct icons for all platform types', () {
      expect(PlatformType.steam.icon, 'assets/icons/steam.svg');
      expect(PlatformType.xbox.icon, 'assets/icons/xbox.svg');
      expect(PlatformType.playstation.icon, 'assets/icons/playstation.svg');
      expect(PlatformType.epicGames.icon, 'assets/icons/epic.svg');
      expect(PlatformType.gog.icon, 'assets/icons/gog.svg');
      expect(PlatformType.nintendo.icon, 'assets/icons/nintendo.svg');
      expect(PlatformType.origin.icon, 'assets/icons/origin.svg');
      expect(PlatformType.uplay.icon, 'assets/icons/uplay.svg');
    });

    test('should return correct colors for all platform types', () {
      expect(PlatformType.steam.color, '1b2838');
      expect(PlatformType.xbox.color, '107c10');
      expect(PlatformType.playstation.color, '003087');
      expect(PlatformType.epicGames.color, '2a2a2a');
      expect(PlatformType.gog.color, '86328a');
      expect(PlatformType.nintendo.color, 'e60012');
      expect(PlatformType.origin.color, 'ff6600');
      expect(PlatformType.uplay.color, '0080ff');
    });
  });
}