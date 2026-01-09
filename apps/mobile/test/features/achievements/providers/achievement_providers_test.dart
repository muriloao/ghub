import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';

import 'package:ghub_mobile/features/achievements/providers/achievement_providers.dart';
import 'package:ghub_mobile/features/games/data/models/steam_achievement_model.dart';
import 'package:ghub_mobile/features/games/data/services/steam_games_service.dart';

@GenerateMocks([SteamGamesService])
import 'achievement_providers_test.mocks.dart';

void main() {
  late MockSteamGamesService mockSteamGamesService;
  late ProviderContainer container;

  setUp(() {
    mockSteamGamesService = MockSteamGamesService();
    container = ProviderContainer(
      overrides: [
        steamGamesServiceProvider.overrideWithValue(mockSteamGamesService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('GameAchievementsState', () {
    test('should create instance with default values', () {
      // arrange & act
      const state = GameAchievementsState();

      // assert
      expect(state.achievements, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, null);
      expect(state.filter, AchievementFilter.all);
    });

    test('should create copy with updated values', () {
      // arrange
      const originalState = GameAchievementsState(isLoading: true);

      // act
      final updatedState = originalState.copyWith(
        isLoading: false,
        error: 'Test error',
      );

      // assert
      expect(updatedState.isLoading, false);
      expect(updatedState.error, 'Test error');
      expect(updatedState.filter, AchievementFilter.all);
    });

    test('should filter achievements correctly', () {
      // arrange
      const userAchievementUnlocked = SteamAchievementModel(
        apiName: 'test_achievement_1',
        achieved: 1,
        unlockTime: 1640995200,
        name: 'Test Achievement 1',
        description: 'Test description',
      );

      const userAchievementLocked = SteamAchievementModel(
        apiName: 'test_achievement_2',
        achieved: 0,
        unlockTime: 0,
        name: 'Test Achievement 2',
        description: 'Test description',
      );

      const schemaUnlocked = SteamAchievementSchemaModel(
        name: 'test_achievement_1',
        displayName: 'Test Achievement 1',
        description: 'Test description',
        iconUrl: 'icon.jpg',
        iconGrayUrl: 'icongray.jpg',
      );

      const schemaLocked = SteamAchievementSchemaModel(
        name: 'test_achievement_2',
        displayName: 'Test Achievement 2',
        description: 'Test description',
        iconUrl: 'icon.jpg',
        iconGrayUrl: 'icongray.jpg',
      );

      final unlockedAchievement = CompleteSteamAchievementModel(
        userAchievement: userAchievementUnlocked,
        schema: schemaUnlocked,
        globalPercentage: 50.0,
      );

      final lockedAchievement = CompleteSteamAchievementModel(
        userAchievement: userAchievementLocked,
        schema: schemaLocked,
        globalPercentage: 10.0,
      );

      // test all filter
      final stateAll = GameAchievementsState(
        achievements: [unlockedAchievement, lockedAchievement],
        filter: AchievementFilter.all,
      );
      expect(stateAll.filteredAchievements.length, 2);

      // test unlocked filter
      final stateUnlocked = GameAchievementsState(
        achievements: [unlockedAchievement, lockedAchievement],
        filter: AchievementFilter.unlocked,
      );
      expect(stateUnlocked.filteredAchievements.length, 1);
      expect(stateUnlocked.filteredAchievements.first.isUnlocked, true);

      // test locked filter
      final stateLocked = GameAchievementsState(
        achievements: [unlockedAchievement, lockedAchievement],
        filter: AchievementFilter.locked,
      );
      expect(stateLocked.filteredAchievements.length, 1);
      expect(stateLocked.filteredAchievements.first.isUnlocked, false);
    });
  });

  group('Achievement Providers', () {
    test('should provide SteamGamesService instance', () {
      // act
      final service = container.read(steamGamesServiceProvider);

      // assert
      expect(service, isA<SteamGamesService>());
    });
  });
}
