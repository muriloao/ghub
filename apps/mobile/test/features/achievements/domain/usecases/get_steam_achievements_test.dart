import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:ghub_mobile/features/achievements/domain/usecases/get_steam_achievements.dart';
import 'package:ghub_mobile/features/achievements/domain/repositories/achievements_repository.dart';
import 'package:ghub_mobile/features/achievements/domain/entities/achievement.dart';
import 'package:ghub_mobile/core/error/failures.dart';

@GenerateMocks([AchievementsRepository])
import 'get_steam_achievements_test.mocks.dart';

void main() {
  late GetSteamAchievements usecase;
  late MockAchievementsRepository mockAchievementsRepository;

  setUp(() {
    mockAchievementsRepository = MockAchievementsRepository();
    usecase = GetSteamAchievements(mockAchievementsRepository);
  });

  group('GetSteamAchievements', () {
    const steamId = '76561198000000000';
    const appId = '12345';
    
    final achievements = [
      Achievement(
        id: 'achievement-1',
        name: 'First Steps',
        description: 'Complete the tutorial',
        iconUrl: 'https://example.com/icon1.jpg',
        iconGrayUrl: 'https://example.com/icon1_gray.jpg',
        isUnlocked: true,
        unlockedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        gameId: appId,
        platform: 'steam',
      ),
      Achievement(
        id: 'achievement-2',
        name: 'Master Player',
        description: 'Reach level 100',
        iconUrl: 'https://example.com/icon2.jpg',
        iconGrayUrl: 'https://example.com/icon2_gray.jpg',
        isUnlocked: false,
        unlockedAt: null,
        gameId: appId,
        platform: 'steam',
      ),
    ];

    test('should get steam achievements from repository', () async {
      // arrange
      when(mockAchievementsRepository.getSteamAchievements(any, any))
          .thenAnswer((_) async => Right(achievements));

      // act
      final result = await usecase(GetSteamAchievementsParams(
        steamId: steamId,
        appId: appId,
      ));

      // assert
      expect(result, Right(achievements));
      verify(mockAchievementsRepository.getSteamAchievements(steamId, appId));
      verifyNoMoreInteractions(mockAchievementsRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // arrange
      when(mockAchievementsRepository.getSteamAchievements(any, any))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Steam API error')));

      // act
      final result = await usecase(GetSteamAchievementsParams(
        steamId: steamId,
        appId: appId,
      ));

      // assert
      expect(result, const Left(ServerFailure(message: 'Steam API error')));
      verify(mockAchievementsRepository.getSteamAchievements(steamId, appId));
    });

    test('should return NetworkFailure when network error occurs', () async {
      // arrange
      when(mockAchievementsRepository.getSteamAchievements(any, any))
          .thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

      // act
      final result = await usecase(GetSteamAchievementsParams(
        steamId: steamId,
        appId: appId,
      ));

      // assert
      expect(result, const Left(NetworkFailure(message: 'No internet connection')));
      verify(mockAchievementsRepository.getSteamAchievements(steamId, appId));
    });

    test('should return empty list when game has no achievements', () async {
      // arrange
      when(mockAchievementsRepository.getSteamAchievements(any, any))
          .thenAnswer((_) async => const Right([]));

      // act
      final result = await usecase(GetSteamAchievementsParams(
        steamId: steamId,
        appId: appId,
      ));

      // assert
      expect(result, const Right([]));
      verify(mockAchievementsRepository.getSteamAchievements(steamId, appId));
    });

    test('should handle achievements with missing optional fields', () async {
      // arrange
      final minimalAchievements = [
        Achievement(
          id: 'achievement-minimal',
          name: 'Minimal Achievement',
          description: 'A minimal achievement',
          iconUrl: 'https://example.com/icon.jpg',
          iconGrayUrl: 'https://example.com/icon_gray.jpg',
          isUnlocked: false,
          unlockedAt: null,
          gameId: appId,
          platform: 'steam',
        ),
      ];

      when(mockAchievementsRepository.getSteamAchievements(any, any))
          .thenAnswer((_) async => Right(minimalAchievements));

      // act
      final result = await usecase(GetSteamAchievementsParams(
        steamId: steamId,
        appId: appId,
      ));

      // assert
      expect(result, Right(minimalAchievements));
      final achievement = (result as Right).value.first as Achievement;
      expect(achievement.isUnlocked, false);
      expect(achievement.unlockedAt, null);
    });
  });

  group('GetSteamAchievementsParams', () {
    test('should create params with steamId and appId', () {
      // arrange & act
      const steamId = '76561198000000000';
      const appId = '12345';
      final params = GetSteamAchievementsParams(
        steamId: steamId,
        appId: appId,
      );

      // assert
      expect(params.steamId, steamId);
      expect(params.appId, appId);
    });
  });
}