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
      expect(platform.username, null);
      expect(platform.connectedAt, null);
    });

    test('should create GamingPlatform with optional fields', () {
      // arrange & act
      final platform = GamingPlatform(
        type: PlatformType.xbox,
        isConnected: true,
        username: 'XboxGamer',
        connectedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      // assert
      expect(platform.type, PlatformType.xbox);
      expect(platform.isConnected, true);
      expect(platform.username, 'XboxGamer');
      expect(platform.connectedAt, DateTime.parse('2024-01-01T00:00:00Z'));
    });

    test('should support equality comparison', () {
      // arrange
      const platform1 = GamingPlatform(
        type: PlatformType.steam,
        isConnected: true,
        username: 'user-123',
      );
      const platform2 = GamingPlatform(
        type: PlatformType.steam,
        isConnected: true,
        username: 'user-123',
      );
      const differentPlatform = GamingPlatform(
        type: PlatformType.xbox,
        isConnected: true,
        username: 'user-456',
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
      );

      // act
      final updatedPlatform = originalPlatform.copyWith(
        isConnected: true,
        username: 'SteamUser',
        connectedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      // assert
      expect(updatedPlatform.isConnected, true);
      expect(updatedPlatform.username, 'SteamUser');
      expect(
        updatedPlatform.connectedAt,
        DateTime.parse('2024-01-01T00:00:00Z'),
      );
      expect(updatedPlatform.type, originalPlatform.type);
    });

    test('should have correct props for Equatable', () {
      // arrange
      final platform = GamingPlatform(
        type: PlatformType.steam,
        isConnected: true,
        username: 'TestUser',
        connectedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      // assert
      expect(platform.props.length, 4);
      expect(platform.props.contains(PlatformType.steam), true);
      expect(platform.props.contains(true), true);
      expect(platform.props.contains('TestUser'), true);
      expect(
        platform.props.contains(DateTime.parse('2024-01-01T00:00:00Z')),
        true,
      );
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
      expect(PlatformType.origin.description, 'Games • Achievements');
      expect(PlatformType.uplay.description, 'Games • Achievements');
    });

    test(
      'should return correct backgroundColor colors for all platform types',
      () {
        expect(PlatformType.steam.backgroundColor, '#171a21');
        expect(PlatformType.xbox.backgroundColor, '#107C10');
        expect(PlatformType.playstation.backgroundColor, '#003791');
        expect(PlatformType.epicGames.backgroundColor, '#333333');
        expect(PlatformType.gog.backgroundColor, '#86328A');
        expect(PlatformType.nintendo.backgroundColor, '#E60012');
        expect(PlatformType.origin.backgroundColor, '#FF6600');
        expect(PlatformType.uplay.backgroundColor, '#0678BE');
      },
    );

    test('should return correct iconName for all platform types', () {
      expect(PlatformType.steam.iconName, 'sports_esports');
      expect(PlatformType.xbox.iconName, 'X');
      expect(PlatformType.playstation.iconName, 'PS');
      expect(PlatformType.epicGames.iconName, 'change_history');
      expect(PlatformType.gog.iconName, 'GOG');
      expect(PlatformType.nintendo.iconName, 'gamepad');
      expect(PlatformType.origin.iconName, 'circle');
      expect(PlatformType.uplay.iconName, 'shield');
    });
  });
}
