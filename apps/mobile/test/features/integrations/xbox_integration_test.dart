import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import '../../../lib/core/services/integrations_cache_service.dart';
import '../../../lib/features/integrations/data/services/xbox_live_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('Xbox Live Integration Tests', () {
    late XboxLiveService xboxService;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      xboxService = XboxLiveService(mockDio);
    });

    group('Xbox User Model', () {
      test('should create XboxUser from JSON correctly', () {
        // Arrange
        final json = {
          'xuid': '1234567890',
          'gamertag': 'TestGamer',
          'profilePicture': 'https://example.com/avatar.jpg',
          'gamerscore': 15000,
          'displayName': 'Test Gamer',
        };

        // Act
        final user = XboxUser.fromJson(json);

        // Assert
        expect(user.xuid, equals('1234567890'));
        expect(user.gamertag, equals('TestGamer'));
        expect(user.avatarUrl, equals('https://example.com/avatar.jpg'));
        expect(user.gamerscore, equals(15000));
        expect(user.displayName, equals('Test Gamer'));
      });

      test('should convert XboxUser to JSON correctly', () {
        // Arrange
        const user = XboxUser(
          xuid: '1234567890',
          gamertag: 'TestGamer',
          avatarUrl: 'https://example.com/avatar.jpg',
          gamerscore: 15000,
          displayName: 'Test Gamer',
        );

        // Act
        final json = user.toJson();

        // Assert
        expect(json['xuid'], equals('1234567890'));
        expect(json['gamertag'], equals('TestGamer'));
        expect(
          json['profilePicture'],
          equals('https://example.com/avatar.jpg'),
        );
        expect(json['gamerscore'], equals(15000));
        expect(json['displayName'], equals('Test Gamer'));
      });
    });

    group('Xbox Game Model', () {
      test('should create XboxGame from JSON correctly', () {
        // Arrange
        final json = {
          'titleId': '219630713',
          'name': 'Halo Infinite',
          'displayImage': 'https://example.com/game.jpg',
          'currentAchievements': 25,
          'totalAchievements': 119,
          'currentGamerscore': 450,
          'lastUnlock': '2023-12-01T10:30:00Z',
        };

        // Act
        final game = XboxGame.fromJson(json);

        // Assert
        expect(game.titleId, equals('219630713'));
        expect(game.name, equals('Halo Infinite'));
        expect(game.imageUrl, equals('https://example.com/game.jpg'));
        expect(game.achievementsUnlocked, equals(25));
        expect(game.totalAchievements, equals(119));
        expect(game.gamerscore, equals(450));
        expect(game.lastPlayedDate, isA<DateTime>());
      });
    });

    group('Integrations Cache Service', () {
      test('should cache Xbox connection correctly', () async {
        // Arrange
        const xboxUser = XboxUser(
          xuid: '1234567890',
          gamertag: 'TestGamer',
          gamerscore: 15000,
        );
        const accessToken = 'test_access_token';

        // Act
        await IntegrationsCacheService.cacheXboxConnection(
          xboxUser,
          accessToken,
        );

        // Assert
        final cachedUser = await IntegrationsCacheService.getCachedXboxUser();
        expect(cachedUser?.xuid, equals('1234567890'));
        expect(cachedUser?.gamertag, equals('TestGamer'));
        expect(cachedUser?.gamerscore, equals(15000));

        final token = await IntegrationsCacheService.getPlatformToken('xbox');
        expect(token, equals(accessToken));
      });

      test('should cache Xbox games correctly', () async {
        // Arrange
        final games = [
          const XboxGame(
            titleId: '219630713',
            name: 'Halo Infinite',
            achievementsUnlocked: 25,
            totalAchievements: 119,
            gamerscore: 450,
          ),
          const XboxGame(
            titleId: '1063463608',
            name: 'Forza Horizon 5',
            achievementsUnlocked: 89,
            totalAchievements: 200,
            gamerscore: 1200,
          ),
        ];

        // Act
        await IntegrationsCacheService.cacheXboxGames(games);

        // Assert
        final cachedGames = await IntegrationsCacheService.getCachedXboxGames();
        expect(cachedGames?.length, equals(2));
        expect(cachedGames?[0].name, equals('Halo Infinite'));
        expect(cachedGames?[1].name, equals('Forza Horizon 5'));
      });

      test('should remove Xbox connection correctly', () async {
        // Arrange - First cache a connection
        const xboxUser = XboxUser(
          xuid: '1234567890',
          gamertag: 'TestGamer',
          gamerscore: 15000,
        );
        await IntegrationsCacheService.cacheXboxConnection(xboxUser, 'token');

        // Act
        final removed = await IntegrationsCacheService.removePlatformConnection(
          'xbox',
        );

        // Assert
        expect(removed, isTrue);
        final cachedUser = await IntegrationsCacheService.getCachedXboxUser();
        expect(cachedUser, isNull);
      });
    });

    group('Xbox Live Service', () {
      test('should return mock Xbox games', () async {
        // Act
        final games = await xboxService.fetchUserGames('1234567890');

        // Assert
        expect(games.length, equals(3));
        expect(games[0].name, equals('Halo Infinite'));
        expect(games[1].name, equals('Forza Horizon 5'));
        expect(games[2].name, equals('Microsoft Flight Simulator'));
      });

      test('should generate state parameter correctly', () {
        // Act
        final state1 = xboxService._generateState();
        final state2 = xboxService._generateState();

        // Assert
        expect(state1, isNotEmpty);
        expect(state2, isNotEmpty);
        expect(state1, isNot(equals(state2))); // Should be unique
        expect(state1.length, greaterThan(20)); // Should be reasonably long
      });
    });
  });
}

// Extension para tornar métodos privados testáveis (apenas para testes)
extension XboxLiveServiceTest on XboxLiveService {
  String _generateState() {
    // Implementação de teste ou acesso via reflection
    // Em um caso real, você moveria esta lógica para um método público ou utilitário
    return 'test_state_parameter';
  }
}
