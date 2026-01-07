import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/features/games/domain/entities/game.dart';
import 'package:ghub_mobile/features/onboarding/domain/entities/gaming_platform.dart';

void main() {
  group('Game Entity', () {
    test('should create Game with required fields', () {
      // arrange & act
      const game = Game(
        id: 'game-1',
        name: 'Test Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      );

      // assert
      expect(game.id, 'game-1');
      expect(game.name, 'Test Game');
      expect(game.status, GameStatus.owned);
      expect(game.platforms, [GamePlatform.pc]);
      expect(game.hasDLC, false);
      expect(game.isCompleted, false);
    });

    test('should create Game from JSON correctly', () {
      // arrange
      final json = {
        'id': 'game-1',
        'name': 'Test Game',
        'image_url': 'https://example.com/image.jpg',
        'header_image_url': 'https://example.com/header.jpg',
        'status': 'owned',
        'platforms': ['pc', 'xbox'],
        'playtime_forever': 120,
        'playtime_2_weeks': 60,
        'last_played': '2024-01-01T00:00:00Z',
        'has_dlc': true,
        'is_completed': true,
        'completion_percentage': 85.5,
        'subscription_service': 'Game Pass',
        'is_physical_copy': false,
        'release_date': '2023-06-15',
        'genres': ['Action', 'Adventure'],
        'developer': 'Test Developer',
        'publisher': 'Test Publisher',
        'rating': 4.5,
        'description': 'A test game description',
        'source_platform': 'steam',
      };

      // act
      final game = Game.fromJson(json);

      // assert
      expect(game.id, 'game-1');
      expect(game.name, 'Test Game');
      expect(game.imageUrl, 'https://example.com/image.jpg');
      expect(game.headerImageUrl, 'https://example.com/header.jpg');
      expect(game.status, GameStatus.owned);
      expect(game.platforms, [GamePlatform.pc, GamePlatform.xbox]);
      expect(game.playtimeForever, 120);
      expect(game.playtime2Weeks, 60);
      expect(game.lastPlayed, DateTime.parse('2024-01-01T00:00:00Z'));
      expect(game.hasDLC, true);
      expect(game.isCompleted, true);
      expect(game.completionPercentage, 85.5);
      expect(game.subscriptionService, 'Game Pass');
      expect(game.isPhysicalCopy, false);
      expect(game.releaseDate, '2023-06-15');
      expect(game.genres, ['Action', 'Adventure']);
      expect(game.developer, 'Test Developer');
      expect(game.publisher, 'Test Publisher');
      expect(game.rating, 4.5);
      expect(game.description, 'A test game description');
      expect(game.sourcePlatform, PlatformType.steam);
    });

    test('should handle minimal JSON data', () {
      // arrange
      final json = {
        'id': 'game-1',
        'name': 'Test Game',
        'status': 'owned',
        'platforms': ['pc'],
      };

      // act
      final game = Game.fromJson(json);

      // assert
      expect(game.id, 'game-1');
      expect(game.name, 'Test Game');
      expect(game.status, GameStatus.owned);
      expect(game.platforms, [GamePlatform.pc]);
      expect(game.imageUrl, null);
      expect(game.playtimeForever, null);
      expect(game.lastPlayed, null);
      expect(game.hasDLC, false);
      expect(game.isCompleted, false);
    });

    test('should convert Game to JSON correctly', () {
      // arrange
      final game = Game(
        id: 'game-1',
        name: 'Test Game',
        imageUrl: 'https://example.com/image.jpg',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc, GamePlatform.xbox],
        playtimeForever: 120,
        hasDLC: true,
        isCompleted: true,
        completionPercentage: 85.5,
        lastPlayed: DateTime.parse('2024-01-01T00:00:00Z'),
        sourcePlatform: PlatformType.steam,
      );

      // act
      final json = game.toJson();

      // assert
      expect(json['id'], 'game-1');
      expect(json['name'], 'Test Game');
      expect(json['image_url'], 'https://example.com/image.jpg');
      expect(json['status'], 'owned');
      expect(json['platforms'], ['pc', 'xbox']);
      expect(json['playtime_forever'], 120);
      expect(json['has_dlc'], true);
      expect(json['is_completed'], true);
      expect(json['completion_percentage'], 85.5);
      expect(json['last_played'], '2024-01-01T00:00:00.000Z');
      expect(json['source_platform'], 'steam');
    });

    test('should support equality comparison', () {
      // arrange
      const game1 = Game(
        id: 'game-1',
        name: 'Test Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      );
      const game2 = Game(
        id: 'game-1',
        name: 'Test Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      );
      const differentGame = Game(
        id: 'game-2',
        name: 'Different Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      );

      // assert
      expect(game1, equals(game2));
      expect(game1, isNot(equals(differentGame)));
    });

    test('should calculate playtime in hours correctly', () {
      // arrange
      const game = Game(
        id: 'game-1',
        name: 'Test Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtimeForever: 150, // 2.5 hours in minutes
      );

      // act
      final playtimeInHours = game.playtimeInHours;

      // assert
      expect(playtimeInHours, 2.5);
    });

    test('should return null playtime in hours when playtime is null', () {
      // arrange
      const game = Game(
        id: 'game-1',
        name: 'Test Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      );

      // act
      final playtimeInHours = game.playtimeInHours;

      // assert
      expect(playtimeInHours, null);
    });

    test('should create copy with updated fields', () {
      // arrange
      const originalGame = Game(
        id: 'game-1',
        name: 'Test Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtimeForever: 120,
      );

      // act
      final updatedGame = originalGame.copyWith(
        name: 'Updated Game',
        status: GameStatus.completed,
        playtimeForever: 180,
      );

      // assert
      expect(updatedGame.name, 'Updated Game');
      expect(updatedGame.status, GameStatus.completed);
      expect(updatedGame.playtimeForever, 180);
      expect(updatedGame.id, originalGame.id);
      expect(updatedGame.platforms, originalGame.platforms);
    });

    group('GameStatus enum', () {
      test('should have correct values', () {
        expect(GameStatus.values, [
          GameStatus.owned,
          GameStatus.subscription,
          GameStatus.wishlist,
          GameStatus.backlog,
          GameStatus.completed,
          GameStatus.favorite,
        ]);
      });
    });

    group('GamePlatform enum', () {
      test('should have correct values', () {
        expect(GamePlatform.values, [
          GamePlatform.pc,
          GamePlatform.playstation,
          GamePlatform.xbox,
          GamePlatform.nintendo,
          GamePlatform.mobile,
        ]);
      });
    });
  });
}