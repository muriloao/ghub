import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

import 'package:ghub_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:ghub_mobile/features/auth/domain/entities/user.dart';
import 'package:ghub_mobile/features/auth/domain/entities/auth_result.dart';
import 'package:ghub_mobile/core/error/failures.dart';

import '../../../helpers/test_helpers.dart';
import '../domain/usecases/login_with_credentials_test.mocks.dart';

void main() {
  group('Auth Providers', () {
    late ProviderContainer container;
    late MockSharedPreferences mockSharedPreferences;
    late MockDio mockDio;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      mockDio = MockDio();
      
      container = createMockContainer(
        mockSharedPreferences: mockSharedPreferences,
        mockDio: mockDio,
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('authRepositoryProvider', () {
      test('should provide AuthRepository instance', () {
        // arrange & act
        final repository = container.read(authRepositoryProvider);

        // assert
        expect(repository, isNotNull);
      });
    });

    group('loginWithCredentialsProvider', () {
      test('should provide LoginWithCredentials usecase', () {
        // arrange & act
        final usecase = container.read(loginWithCredentialsProvider);

        // assert
        expect(usecase, isNotNull);
      });
    });

    group('authStateProvider', () {
      test('should provide initial auth state as not authenticated', () {
        // arrange & act
        final authState = container.read(authStateProvider);

        // assert
        expect(authState.isAuthenticated, false);
        expect(authState.user, null);
        expect(authState.isLoading, false);
        expect(authState.error, null);
      });

      test('should update state when login is successful', () async {
        // arrange
        final mockRepository = MockAuthRepository();
        final authResult = AuthResult(
          user: TestFixtures.userJson,
          accessToken: TestFixtures.accessToken,
          refreshToken: TestFixtures.refreshToken,
        );
        
        when(mockRepository.loginWithCredentials(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => Right(authResult));

        // Override with mock repository
        final testContainer = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepository),
          ],
        );

        // act
        final notifier = testContainer.read(authStateProvider.notifier);
        await notifier.loginWithCredentials(
          TestFixtures.validEmail,
          TestFixtures.validPassword,
        );

        // assert
        final finalState = testContainer.read(authStateProvider);
        expect(finalState.isAuthenticated, true);
        expect(finalState.user, isNotNull);
        expect(finalState.isLoading, false);
        expect(finalState.error, null);

        testContainer.dispose();
      });

      test('should update state with error when login fails', () async {
        // arrange
        final mockRepository = MockAuthRepository();
        
        when(mockRepository.loginWithCredentials(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Login failed')));

        // Override with mock repository
        final testContainer = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepository),
          ],
        );

        // act
        final notifier = testContainer.read(authStateProvider.notifier);
        await notifier.loginWithCredentials(
          TestFixtures.validEmail,
          TestFixtures.validPassword,
        );

        // assert
        final finalState = testContainer.read(authStateProvider);
        expect(finalState.isAuthenticated, false);
        expect(finalState.user, null);
        expect(finalState.isLoading, false);
        expect(finalState.error, 'Login failed');

        testContainer.dispose();
      });

      test('should set loading state during login', () async {
        // arrange
        final mockRepository = MockAuthRepository();
        final authResult = AuthResult(
          user: TestFixtures.userJson,
          accessToken: TestFixtures.accessToken,
          refreshToken: TestFixtures.refreshToken,
        );
        
        when(mockRepository.loginWithCredentials(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async {
          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(authResult);
        });

        // Override with mock repository
        final testContainer = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepository),
          ],
        );

        // act
        final notifier = testContainer.read(authStateProvider.notifier);
        final loginFuture = notifier.loginWithCredentials(
          TestFixtures.validEmail,
          TestFixtures.validPassword,
        );

        // Check loading state immediately after starting login
        final loadingState = testContainer.read(authStateProvider);
        expect(loadingState.isLoading, true);

        // Wait for completion
        await loginFuture;

        // assert final state
        final finalState = testContainer.read(authStateProvider);
        expect(finalState.isLoading, false);

        testContainer.dispose();
      });

      test('should clear state when logout', () async {
        // arrange
        final mockRepository = MockAuthRepository();
        
        when(mockRepository.logout())
            .thenAnswer((_) async => const Right(null));

        // Override with mock repository
        final testContainer = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepository),
          ],
        );

        // Set initial authenticated state
        final notifier = testContainer.read(authStateProvider.notifier);
        notifier.state = notifier.state.copyWith(
          isAuthenticated: true,
          user: User.fromJson(TestFixtures.userJson),
        );

        // act
        await notifier.logout();

        // assert
        final finalState = testContainer.read(authStateProvider);
        expect(finalState.isAuthenticated, false);
        expect(finalState.user, null);
        expect(finalState.error, null);

        testContainer.dispose();
      });
    });
  });
}