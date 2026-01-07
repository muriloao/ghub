import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:ghub_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ghub_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ghub_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ghub_mobile/features/auth/domain/entities/auth_result.dart';
import 'package:ghub_mobile/features/auth/domain/entities/user.dart';
import 'package:ghub_mobile/features/auth/domain/entities/signup_request.dart';
import 'package:ghub_mobile/core/error/exceptions.dart';
import 'package:ghub_mobile/core/error/failures.dart';

import '../../../helpers/test_helpers.dart';

@GenerateMocks([AuthRemoteDataSource, AuthLocalDataSource])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('AuthRepositoryImpl', () {
    final authResult = AuthResult(
      user: TestFixtures.userJson,
      accessToken: TestFixtures.accessToken,
      refreshToken: TestFixtures.refreshToken,
    );

    group('loginWithCredentials', () {
      const email = TestFixtures.validEmail;
      const password = TestFixtures.validPassword;

      test('should return AuthResult when login is successful', () async {
        // arrange
        when(mockRemoteDataSource.loginWithCredentials(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => authResult);
        when(mockLocalDataSource.cacheAuthData(
          accessToken: anyNamed('accessToken'),
          refreshToken: anyNamed('refreshToken'),
          user: any,
        )).thenAnswer((_) async => {});

        // act
        final result = await repository.loginWithCredentials(
          email: email,
          password: password,
        );

        // assert
        expect(result, Right(authResult));
        verify(mockRemoteDataSource.loginWithCredentials(
          email: email,
          password: password,
        ));
        verify(mockLocalDataSource.cacheAuthData(
          accessToken: TestFixtures.accessToken,
          refreshToken: TestFixtures.refreshToken,
          user: any,
        ));
      });

      test('should return AuthenticationFailure when credentials are invalid', () async {
        // arrange
        when(mockRemoteDataSource.loginWithCredentials(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(const AuthenticationException(message: 'Invalid credentials'));

        // act
        final result = await repository.loginWithCredentials(
          email: email,
          password: password,
        );

        // assert
        expect(result, const Left(AuthenticationFailure(message: 'Invalid credentials')));
        verify(mockRemoteDataSource.loginWithCredentials(
          email: email,
          password: password,
        ));
        verifyZeroInteractions(mockLocalDataSource);
      });

      test('should return ServerFailure when server error occurs', () async {
        // arrange
        when(mockRemoteDataSource.loginWithCredentials(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(const ServerException(message: 'Server error'));

        // act
        final result = await repository.loginWithCredentials(
          email: email,
          password: password,
        );

        // assert
        expect(result, const Left(ServerFailure(message: 'Server error')));
        verify(mockRemoteDataSource.loginWithCredentials(
          email: email,
          password: password,
        ));
        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('loginWithGoogle', () {
      test('should return AuthResult when Google login is successful', () async {
        // arrange
        when(mockRemoteDataSource.loginWithGoogle())
            .thenAnswer((_) async => authResult);
        when(mockLocalDataSource.cacheAuthData(
          accessToken: anyNamed('accessToken'),
          refreshToken: anyNamed('refreshToken'),
          user: any,
        )).thenAnswer((_) async => {});

        // act
        final result = await repository.loginWithGoogle();

        // assert
        expect(result, Right(authResult));
        verify(mockRemoteDataSource.loginWithGoogle());
        verify(mockLocalDataSource.cacheAuthData(
          accessToken: TestFixtures.accessToken,
          refreshToken: TestFixtures.refreshToken,
          user: any,
        ));
      });

      test('should return AuthenticationFailure when Google login fails', () async {
        // arrange
        when(mockRemoteDataSource.loginWithGoogle())
            .thenThrow(const AuthenticationException(message: 'Google login cancelled'));

        // act
        final result = await repository.loginWithGoogle();

        // assert
        expect(result, const Left(AuthenticationFailure(message: 'Google login cancelled')));
        verify(mockRemoteDataSource.loginWithGoogle());
        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('logout', () {
      test('should return Right(null) when logout is successful', () async {
        // arrange
        when(mockLocalDataSource.clearAuthData())
            .thenAnswer((_) async => {});

        // act
        final result = await repository.logout();

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.clearAuthData());
      });

      test('should return CacheFailure when clearing cache fails', () async {
        // arrange
        when(mockLocalDataSource.clearAuthData())
            .thenThrow(const CacheException(message: 'Failed to clear cache'));

        // act
        final result = await repository.logout();

        // assert
        expect(result, const Left(CacheFailure(message: 'Failed to clear cache')));
        verify(mockLocalDataSource.clearAuthData());
      });
    });

    group('getCurrentUser', () {
      test('should return User when user is cached', () async {
        // arrange
        final user = User.fromJson(TestFixtures.userJson);
        when(mockLocalDataSource.getCachedUser())
            .thenAnswer((_) async => user);

        // act
        final result = await repository.getCurrentUser();

        // assert
        expect(result, Right(user));
        verify(mockLocalDataSource.getCachedUser());
      });

      test('should return CacheFailure when no user is cached', () async {
        // arrange
        when(mockLocalDataSource.getCachedUser())
            .thenThrow(const CacheException(message: 'No user found in cache'));

        // act
        final result = await repository.getCurrentUser();

        // assert
        expect(result, const Left(CacheFailure(message: 'No user found in cache')));
        verify(mockLocalDataSource.getCachedUser());
      });
    });
  });
}