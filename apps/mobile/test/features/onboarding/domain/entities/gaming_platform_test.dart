import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/features/integrations/domain/entities/gaming_platform.dart';

void main() {
  group('GamingPlatform Entity', () {
    test('should create GamingPlatform with required fields', () {
      // arrange & act
      const platform = GamingPlatform(
        id: 'platform-1',
        name: 'Steam',
        description: 'Games • Achievements • Friends',
        type: PlatformType.steam,
        status: ConnectionStatus.disconnected,
        primaryColor: Color(0xFF171A21),
        backgroundColor: Color(0x1A171A21),
        icon: Icons.sports_esports,
        features: [],
      );

      // assert
      expect(platform.type, PlatformType.steam);
      expect(platform.isConnected, false);
      expect(platform.connectedUsername, null);
      expect(platform.connectedAt, null);
    });

    test('should create GamingPlatform with optional fields', () {
      // arrange & act
      final platform = GamingPlatform(
        id: 'platform-2',
        name: 'Xbox',
        description: 'Games • Friends',
        type: PlatformType.xbox,
        status: ConnectionStatus.connected,
        primaryColor: Color(0xFF107C10),
        backgroundColor: Color(0x1A107C10),
        icon: Icons.one_x_mobiledata,
        features: ['Cloud Saves', 'Achievements'],
        connectedUsername: 'XboxGamer',
        connectedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      // assert
      expect(platform.type, PlatformType.xbox);
      expect(platform.isConnected, true);
      expect(platform.connectedUsername, 'XboxGamer');
      expect(platform.connectedAt, DateTime.parse('2024-01-01T00:00:00Z'));
    });

    test('should support equality comparison', () {
      // arrange
      const platform1 = GamingPlatform(
        id: 'platform-1',
        name: 'Steam',
        description: 'Games • Achievements • Friends',
        type: PlatformType.steam,
        status: ConnectionStatus.disconnected,
        primaryColor: Color(0xFF171A21),
        backgroundColor: Color(0x1A171A21),
        icon: Icons.sports_esports,
        features: [],
        connectedUsername: 'user-123',
      );
      const platform2 = GamingPlatform(
        id: 'platform-2',
        name: 'Xbox',
        description: 'Games',
        type: PlatformType.xbox,
        status: ConnectionStatus.disconnected,
        primaryColor: Color(0xFF171A21),
        backgroundColor: Color(0x1A171A21),
        icon: Icons.sports_esports,
        features: [],
        connectedUsername: 'user-123',
      );
      const differentPlatform = GamingPlatform(
        id: 'platform-3',
        name: 'Epic Games',
        description: 'Games',
        type: PlatformType.epicGames,
        status: ConnectionStatus.disconnected,
        primaryColor: Color(0xFF171A21),
        backgroundColor: Color(0x1A171A21),
        icon: Icons.sports_esports,
        features: [],
        connectedUsername: 'user-456',
      );

      // assert
      expect(platform1, isNot(equals(platform2))); // Different IDs and types
      expect(platform1, isNot(equals(differentPlatform)));
    });

    test('should create copy with updated fields', () {
      // arrange
      const originalPlatform = GamingPlatform(
        id: 'steam-1',
        name: 'Steam',
        description: 'Steam Platform',
        type: PlatformType.steam,
        status: ConnectionStatus.disconnected,
        primaryColor: Color(0xFF171A21),
        backgroundColor: Color(0x1A171A21),
        icon: Icons.sports_esports,
        features: [],
      );

      // act
      final updatedPlatform = originalPlatform.copyWith(
        status: ConnectionStatus.connected,
        connectedUsername: 'SteamUser',
        connectedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      // assert
      expect(updatedPlatform.isConnected, true);
      expect(updatedPlatform.connectedUsername, 'SteamUser');
      expect(
        updatedPlatform.connectedAt,
        DateTime.parse('2024-01-01T00:00:00Z'),
      );
      expect(updatedPlatform.type, originalPlatform.type);
    });

    test('should calculate hashCode correctly', () {
      // arrange
      final platform1 = GamingPlatform(
        id: 'steam-1',
        name: 'Steam',
        description: 'Steam Platform',
        type: PlatformType.steam,
        status: ConnectionStatus.connected,
        primaryColor: Color(0xFF171A21),
        backgroundColor: Color(0x1A171A21),
        icon: Icons.sports_esports,
        features: [],
        connectedUsername: 'TestUser',
        connectedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      final platform2 = GamingPlatform(
        id: 'steam-1',
        name: 'Steam',
        description: 'Steam Platform',
        type: PlatformType.steam,
        status: ConnectionStatus.connected,
        primaryColor: Color(0xFF171A21),
        backgroundColor: Color(0x1A171A21),
        icon: Icons.sports_esports,
        features: [],
        connectedUsername:
            'DifferentUser', // Different user but same core fields
      );

      // assert - hashCode should be same for platforms with same id, name, type, status
      expect(platform1.hashCode, platform2.hashCode);
    });
  });

  group('PlatformType Enum', () {
    test('should have all expected platform types', () {
      final expectedTypes = [
        PlatformType.steam,
        PlatformType.xbox,
        PlatformType.playstation,
        PlatformType.epicGames,
        PlatformType.gogGalaxy,
        PlatformType.uplay,
        PlatformType.eaPlay,
        PlatformType.origin,
        PlatformType.battleNet,
        PlatformType.amazonGames,
        PlatformType.nintendo,
        PlatformType.gog,
      ];

      expect(PlatformType.values.length, expectedTypes.length);
      for (final type in expectedTypes) {
        expect(PlatformType.values.contains(type), true);
      }
    });

    test('should have correct enum names', () {
      expect(PlatformType.steam.name, 'steam');
      expect(PlatformType.xbox.name, 'xbox');
      expect(PlatformType.playstation.name, 'playstation');
      expect(PlatformType.epicGames.name, 'epicGames');
      expect(PlatformType.gogGalaxy.name, 'gogGalaxy');
      expect(PlatformType.gog.name, 'gog');
    });
  });
}
