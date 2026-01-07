import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:ghub_mobile/features/profile/domain/usecases/get_user_profile.dart';
import 'package:ghub_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:ghub_mobile/features/profile/domain/entities/user_profile.dart';
import 'package:ghub_mobile/core/error/failures.dart';

@GenerateMocks([ProfileRepository])
import 'get_user_profile_test.mocks.dart';

void main() {
  late GetUserProfile usecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = GetUserProfile(mockProfileRepository);
  });

  group('GetUserProfile', () {
    const userId = 'user-123';
    
    final userProfile = UserProfile(
      id: userId,
      displayName: 'Test User',
      email: 'test@example.com',
      avatarUrl: 'https://example.com/avatar.jpg',
      preferences: const UserPreferences(
        theme: ThemeMode.dark,
        language: 'pt_BR',
        notificationsEnabled: true,
      ),
      statistics: const UserStatistics(
        totalGames: 150,
        totalPlatforms: 3,
        totalPlaytime: 2500,
        achievementsUnlocked: 456,
      ),
    );

    test('should get user profile from repository', () async {
      // arrange
      when(mockProfileRepository.getUserProfile(any))
          .thenAnswer((_) async => Right(userProfile));

      // act
      final result = await usecase(GetUserProfileParams(userId: userId));

      // assert
      expect(result, Right(userProfile));
      verify(mockProfileRepository.getUserProfile(userId));
      verifyNoMoreInteractions(mockProfileRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // arrange
      when(mockProfileRepository.getUserProfile(any))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));

      // act
      final result = await usecase(GetUserProfileParams(userId: userId));

      // assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
      verify(mockProfileRepository.getUserProfile(userId));
    });

    test('should return CacheFailure when profile not found in cache', () async {
      // arrange
      when(mockProfileRepository.getUserProfile(any))
          .thenAnswer((_) async => const Left(CacheFailure(message: 'Profile not found')));

      // act
      final result = await usecase(GetUserProfileParams(userId: userId));

      // assert
      expect(result, const Left(CacheFailure(message: 'Profile not found')));
      verify(mockProfileRepository.getUserProfile(userId));
    });
  });

  group('GetUserProfileParams', () {
    test('should create params with userId', () {
      // arrange & act
      const userId = 'user-123';
      final params = GetUserProfileParams(userId: userId);

      // assert
      expect(params.userId, userId);
    });
  });
}