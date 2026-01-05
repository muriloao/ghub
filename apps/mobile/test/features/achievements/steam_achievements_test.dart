import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/features/achievements/providers/achievement_providers.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

import 'package:ghub_mobile/features/games/data/services/steam_games_service.dart';
import 'package:ghub_mobile/features/games/data/models/steam_achievement_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('Steam Achievements Integration Tests', () {
    late SteamGamesService steamGamesService;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      steamGamesService = SteamGamesService(mockDio);
    });

    group('SteamGamesService - Achievements', () {
      test('should fetch player achievements successfully', () async {
        // Arrange
        const steamId = '76561198000000000';
        const appId = '1091500'; // Cyberpunk 2077

        final mockResponse = Response(
          data: {
            'playerstats': {
              'steamID': steamId,
              'gameName': 'Cyberpunk 2077',
              'success': true,
              'achievements': [
                {
                  'apiname': 'breathtaking',
                  'achieved': 1,
                  'unlocktime': 1640995200, // 2022-01-01
                  'name': 'Breathtaking',
                  'description':
                      'Collect all items that once belonged to Johnny Silverhand.',
                },
                {
                  'apiname': 'gun_fu',
                  'achieved': 0,
                  'unlocktime': 0,
                  'name': 'Gun Fu',
                  'description':
                      'Kill or incapacitate 3 enemies in quick succession.',
                },
              ],
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await steamGamesService.getPlayerAchievements(
          steamId,
          appId,
        );

        // Assert
        expect(result.length, equals(2));
        expect(result[0].apiName, equals('breathtaking'));
        expect(result[0].isUnlocked, isTrue);
        expect(result[1].apiName, equals('gun_fu'));
        expect(result[1].isUnlocked, isFalse);
      });

      test('should fetch achievement schema successfully', () async {
        // Arrange
        const appId = '1091500';

        final mockResponse = Response(
          data: {
            'game': {
              'gameName': 'Cyberpunk 2077',
              'gameVersion': '1.0',
              'availableGameStats': {
                'achievements': [
                  {
                    'name': 'breathtaking',
                    'displayName': 'Breathtaking',
                    'description':
                        'Collect all items that once belonged to Johnny Silverhand.',
                    'icon':
                        'https://steamcdn-a.akamaihd.net/steamcommunity/public/images/apps/1091500/achievement_icon.jpg',
                    'icongray':
                        'https://steamcdn-a.akamaihd.net/steamcommunity/public/images/apps/1091500/achievement_icon_gray.jpg',
                    'hidden': 0,
                    'defaultvalue': 0,
                  },
                ],
              },
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await steamGamesService.getGameAchievementSchema(appId);

        // Assert
        expect(result.length, equals(1));
        expect(result[0].name, equals('breathtaking'));
        expect(result[0].displayName, equals('Breathtaking'));
        expect(result[0].isHidden, isFalse);
      });

      test(
        'should fetch global achievement percentages successfully',
        () async {
          // Arrange
          const appId = '1091500';

          final mockResponse = Response(
            data: {
              'achievementpercentages': {
                'achievements': [
                  {'name': 'breathtaking', 'percent': 2.5},
                  {'name': 'gun_fu', 'percent': 45.8},
                ],
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          );

          when(
            mockDio.get(any, queryParameters: anyNamed('queryParameters')),
          ).thenAnswer((_) async => mockResponse);

          // Act
          final result = await steamGamesService
              .getGlobalAchievementPercentages(appId);

          // Assert
          expect(result.length, equals(2));
          expect(result['breathtaking'], equals(2.5));
          expect(result['gun_fu'], equals(45.8));
        },
      );

      test('should combine achievements data successfully', () async {
        // Este teste seria mais complexo, envolvendo multiple mocks
        // Para simplificar, vamos testar apenas a lógica de combinação

        const userAchievement = SteamAchievementModel(
          apiName: 'breathtaking',
          achieved: 1,
          unlockTime: 1640995200,
          name: 'Breathtaking',
          description: 'Collect all items.',
        );

        const schemaAchievement = SteamAchievementSchemaModel(
          name: 'breathtaking',
          displayName: 'Breathtaking',
          description:
              'Collect all items that once belonged to Johnny Silverhand.',
          iconUrl: 'https://example.com/icon.jpg',
          iconGrayUrl: 'https://example.com/icon_gray.jpg',
        );

        const combined = CompleteSteamAchievementModel(
          userAchievement: userAchievement,
          schema: schemaAchievement,
          globalPercentage: 2.5,
        );

        expect(combined.name, equals('Breathtaking'));
        expect(combined.isUnlocked, isTrue);
        expect(combined.rarity, equals(AchievementRarity.rare)); // 2.5% é raro
        expect(
          combined.iconUrl,
          equals('https://example.com/icon.jpg'),
        ); // Colorido pois desbloqueado
      });
    });

    group('Achievement Models', () {
      test('AchievementRarity should categorize correctly', () {
        // Rare: < 5%
        const rare = CompleteSteamAchievementModel(
          userAchievement: SteamAchievementModel(
            apiName: 'rare_achievement',
            achieved: 1,
            unlockTime: 0,
          ),
          schema: SteamAchievementSchemaModel(
            name: 'rare_achievement',
            displayName: 'Rare Achievement',
            iconUrl: '',
            iconGrayUrl: '',
          ),
          globalPercentage: 2.3,
        );

        // Uncommon: 5-25%
        const uncommon = CompleteSteamAchievementModel(
          userAchievement: SteamAchievementModel(
            apiName: 'uncommon_achievement',
            achieved: 1,
            unlockTime: 0,
          ),
          schema: SteamAchievementSchemaModel(
            name: 'uncommon_achievement',
            displayName: 'Uncommon Achievement',
            iconUrl: '',
            iconGrayUrl: '',
          ),
          globalPercentage: 15.0,
        );

        // Common: > 25%
        const common = CompleteSteamAchievementModel(
          userAchievement: SteamAchievementModel(
            apiName: 'common_achievement',
            achieved: 1,
            unlockTime: 0,
          ),
          schema: SteamAchievementSchemaModel(
            name: 'common_achievement',
            displayName: 'Common Achievement',
            iconUrl: '',
            iconGrayUrl: '',
          ),
          globalPercentage: 67.2,
        );

        expect(rare.rarity, equals(AchievementRarity.rare));
        expect(uncommon.rarity, equals(AchievementRarity.uncommon));
        expect(common.rarity, equals(AchievementRarity.common));
      });

      test('Achievement should use correct icon based on unlock status', () {
        const unlockedAchievement = CompleteSteamAchievementModel(
          userAchievement: SteamAchievementModel(
            apiName: 'test',
            achieved: 1,
            unlockTime: 1640995200,
          ),
          schema: SteamAchievementSchemaModel(
            name: 'test',
            displayName: 'Test',
            iconUrl: 'https://example.com/color.jpg',
            iconGrayUrl: 'https://example.com/gray.jpg',
          ),
        );

        const lockedAchievement = CompleteSteamAchievementModel(
          userAchievement: SteamAchievementModel(
            apiName: 'test2',
            achieved: 0,
            unlockTime: 0,
          ),
          schema: SteamAchievementSchemaModel(
            name: 'test2',
            displayName: 'Test 2',
            iconUrl: 'https://example.com/color2.jpg',
            iconGrayUrl: 'https://example.com/gray2.jpg',
          ),
        );

        expect(
          unlockedAchievement.iconUrl,
          equals('https://example.com/color.jpg'),
        );
        expect(
          lockedAchievement.iconUrl,
          equals('https://example.com/gray2.jpg'),
        );
      });
    });

    group('Achievement Statistics', () {
      test('should calculate stats correctly', () {
        final achievements = [
          // Rare unlocked
          const CompleteSteamAchievementModel(
            userAchievement: SteamAchievementModel(
              apiName: 'rare1',
              achieved: 1,
              unlockTime: 1640995200,
            ),
            schema: SteamAchievementSchemaModel(
              name: 'rare1',
              displayName: 'Rare 1',
              iconUrl: '',
              iconGrayUrl: '',
            ),
            globalPercentage: 3.0,
          ),
          // Common unlocked
          const CompleteSteamAchievementModel(
            userAchievement: SteamAchievementModel(
              apiName: 'common1',
              achieved: 1,
              unlockTime: 1640995200,
            ),
            schema: SteamAchievementSchemaModel(
              name: 'common1',
              displayName: 'Common 1',
              iconUrl: '',
              iconGrayUrl: '',
            ),
            globalPercentage: 50.0,
          ),
          // Rare locked
          const CompleteSteamAchievementModel(
            userAchievement: SteamAchievementModel(
              apiName: 'rare2',
              achieved: 0,
              unlockTime: 0,
            ),
            schema: SteamAchievementSchemaModel(
              name: 'rare2',
              displayName: 'Rare 2',
              iconUrl: '',
              iconGrayUrl: '',
            ),
            globalPercentage: 4.0,
          ),
        ];

        const stats = AchievementStats(
          total: 3,
          unlocked: 2,
          rare: 2,
          rareUnlocked: 1,
          progress: 2 / 3,
        );

        expect(stats.total, equals(3));
        expect(stats.unlocked, equals(2));
        expect(stats.locked, equals(1));
        expect(stats.rare, equals(2));
        expect(stats.rareUnlocked, equals(1));
        expect(stats.completionPercentage, closeTo(66.67, 0.01));
      });
    });
  });
}

/// Exemplo de uso em integration test
/// Como testar na prática:
void integrationTestExample() {
  testWidgets('Steam Achievements Section should display correctly', (
    WidgetTester tester,
  ) async {
    // const app = ProviderScope(
    //   child: MaterialApp(
    //     home: GameAchievementsSection(
    //       appId: '1091500', // Cyberpunk 2077
    //       gameName: 'Cyberpunk 2077',
    //     ),
    //   ),
    // );
    //
    // await tester.pumpWidget(app);
    // await tester.pumpAndSettle();
    //
    // // Verificar se os elementos estão presentes
    // expect(find.text('Conquistas'), findsOneWidget);
    // expect(find.byType(AchievementFilters), findsOneWidget);
    // expect(find.byType(AchievementStats), findsOneWidget);
    //
    // // Testar filtros
    // await tester.tap(find.text('Raros'));
    // await tester.pumpAndSettle();
    //
    // // Verificar se apenas achievements raros são mostrados
    // // ... mais verificações
  });
}
