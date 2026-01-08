import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:ghub_mobile/features/games/domain/usecases/get_user_games.dart';
import 'package:ghub_mobile/features/games/domain/repositories/games_repository.dart';
import 'package:ghub_mobile/features/games/domain/entities/game.dart';
import 'package:ghub_mobile/core/error/failure.dart';

@GenerateMocks([GamesRepository])
import 'get_user_games_test.mocks.dart';

void main() {
  late GetUserGames usecase;
  late MockGamesRepository mockGamesRepository;

  setUp(() {
    mockGamesRepository = MockGamesRepository();
    usecase = GetUserGames(mockGamesRepository);
  });

  group('GetUserGames', () {
    const steamId = '76561198000000000';
    final gamesList = [
      const Game(
        id: 'game-1',
        name: 'Test Game 1',
        status: GameStatus.owned,
        platforms: [GamePlatform.pc],
      ),
      const Game(
        id: 'game-2',
        name: 'Test Game 2',
        status: GameStatus.completed,
        platforms: [GamePlatform.pc],
        playtimeForever: 120,
      ),
    ];

    test('should get user games from repository', () async {
      // arrange
      when(
        mockGamesRepository.getUserGames(any),
      ).thenAnswer((_) async => Right(gamesList));

      // act
      final result = await usecase(GetUserGamesParams(steamId: steamId));

      // assert
      expect(result, Right(gamesList));
      verify(mockGamesRepository.getUserGames(steamId));
      verifyNoMoreInteractions(mockGamesRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // arrange
      when(mockGamesRepository.getUserGames(any)).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Server error')),
      );

      // act
      final result = await usecase(GetUserGamesParams(steamId: steamId));

      // assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
      verify(mockGamesRepository.getUserGames(steamId));
    });

    test('should return NetworkFailure when network error occurs', () async {
      // arrange
      when(mockGamesRepository.getUserGames(any)).thenAnswer(
        (_) async =>
            const Left(NetworkFailure(message: 'No internet connection')),
      );

      // act
      final result = await usecase(GetUserGamesParams(steamId: steamId));

      // assert
      expect(
        result,
        const Left(NetworkFailure(message: 'No internet connection')),
      );
      verify(mockGamesRepository.getUserGames(steamId));
    });

    test('should return empty list when user has no games', () async {
      // arrange
      when(
        mockGamesRepository.getUserGames(any),
      ).thenAnswer((_) async => const Right([]));

      // act
      final result = await usecase(GetUserGamesParams(steamId: steamId));

      // assert
      expect(result, const Right([]));
      verify(mockGamesRepository.getUserGames(steamId));
    });
  });

  group('GetUserGamesParams', () {
    test('should create params with steamId', () {
      // arrange & act
      const steamId = '76561198000000000';
      final params = GetUserGamesParams(steamId: steamId);

      // assert
      expect(params.steamId, steamId);
    });
  });
}
