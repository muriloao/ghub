import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/features/games/domain/entities/game.dart';
import 'package:ghub_mobile/features/integrations/domain/entities/gaming_platform.dart';

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

    test('should create Game with optional fields', () {
      // arrange & act
      const game = Game(
        id: 'game-1',
        name: 'Test Game',
        imageUrl: 'https://example.com/image.jpg',
        headerImageUrl: 'https://example.com/header.jpg',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc, GamePlatform.xbox],
        playtimeForever: 120,
        playtime2Weeks: 60,
        hasDLC: true,
        isCompleted: true,
        completionPercentage: 85.5,
        subscriptionService: 'Game Pass',
        isPhysicalCopy: false,
        releaseDate: '2023-06-15',
        genres: ['Action', 'Adventure'],
        developer: 'Test Developer',
        publisher: 'Test Publisher',
        rating: 4.5,
        description: 'A test game description',
        sourcePlatform: PlatformType.steam,
      );

      // assert
      expect(game.id, 'game-1');
      expect(game.name, 'Test Game');
      expect(game.imageUrl, 'https://example.com/image.jpg');
      expect(game.headerImageUrl, 'https://example.com/header.jpg');
      expect(game.status, GameStatus.owned);
      expect(game.platforms, [GamePlatform.pc, GamePlatform.xbox]);
      expect(game.playtimeForever, 120);
      expect(game.playtime2Weeks, 60);
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

    test('should check if game has been played', () {
      // arrange
      const playedGame = Game(
        id: 'game-1',
        name: 'Played Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtimeForever: 120,
      );

      const unplayedGame = Game(
        id: 'game-2',
        name: 'Unplayed Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtimeForever: 0,
      );

      const neverPlayedGame = Game(
        id: 'game-3',
        name: 'Never Played Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      );

      // assert
      expect(playedGame.hasBeenPlayed, true);
      expect(unplayedGame.hasBeenPlayed, false);
      expect(neverPlayedGame.hasBeenPlayed, false);
    });

    test('should check if game was recently played', () {
      // arrange
      const recentlyPlayedGame = Game(
        id: 'game-1',
        name: 'Recently Played Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtime2Weeks: 60,
      );

      const notRecentlyPlayedGame = Game(
        id: 'game-2',
        name: 'Not Recently Played Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtime2Weeks: 0,
      );

      // assert
      expect(recentlyPlayedGame.recentlyPlayed, true);
      expect(notRecentlyPlayedGame.recentlyPlayed, false);
    });

    test('should format playtime correctly', () {
      // arrange
      const unplayedGame = Game(
        id: 'game-1',
        name: 'Unplayed Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      );

      const minutesGame = Game(
        id: 'game-2',
        name: 'Minutes Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtimeForever: 45,
      );

      const hoursGame = Game(
        id: 'game-3',
        name: 'Hours Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtimeForever: 150, // 2.5 hours
      );

      const longGame = Game(
        id: 'game-4',
        name: 'Long Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtimeForever: 6000, // 100 hours
      );

      // assert
      expect(unplayedGame.playtimeFormatted, 'Not played');
      expect(minutesGame.playtimeFormatted, '45min');
      expect(hoursGame.playtimeFormatted, '2h');
      expect(longGame.playtimeFormatted, '100h');
    });

    test('should format last played correctly when never played', () {
      // arrange
      const neverPlayedGame = Game(
        id: 'game-1',
        name: 'Never Played Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      );

      // assert
      expect(neverPlayedGame.lastPlayedFormatted, 'Never played');
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

    test('should have correct props for Equatable', () {
      // arrange
      const game = Game(
        id: 'game-1',
        name: 'Test Game',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
        playtimeForever: 120,
      );

      // assert
      expect(game.props.length, 21); // All fields should be included in props
      expect(game.props.contains('game-1'), true);
      expect(game.props.contains('Test Game'), true);
      expect(game.props.contains(GameStatus.owned), true);
      expect(game.props.contains([GamePlatform.pc]), true);
      expect(game.props.contains(120), true);
    });
  });
}
