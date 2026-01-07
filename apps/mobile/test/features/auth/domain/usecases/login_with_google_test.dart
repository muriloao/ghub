import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:ghub_mobile/features/auth/domain/usecases/login_with_google.dart';
import 'package:ghub_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:ghub_mobile/features/auth/domain/entities/auth_result.dart';
import 'package:ghub_mobile/core/error/failures.dart';

import '../../../helpers/test_helpers.dart';

@GenerateMocks([AuthRepository])
import 'login_with_google_test.mocks.dart';

void main() {
  late LoginWithGoogle usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginWithGoogle(mockAuthRepository);
  });

  group('LoginWithGoogle', () {
    final authResult = AuthResult(
      user: TestFixtures.userJson,
      accessToken: TestFixtures.accessToken,
      refreshToken: TestFixtures.refreshToken,
    );

    test('should return AuthResult when Google login is successful', () async {
      // arrange
      when(mockAuthRepository.loginWithGoogle())
          .thenAnswer((_) async => Right(authResult));

      // act
      final result = await usecase();

      // assert
      expect(result, Right(authResult));
      verify(mockAuthRepository.loginWithGoogle());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthenticationFailure when Google login fails', () async {
      // arrange
      when(mockAuthRepository.loginWithGoogle())
          .thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Google login failed')));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(AuthenticationFailure(message: 'Google login failed')));
      verify(mockAuthRepository.loginWithGoogle());
    });

    test('should return ServerFailure when server error occurs', () async {
      // arrange
      when(mockAuthRepository.loginWithGoogle())
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
      verify(mockAuthRepository.loginWithGoogle());
    });
  });
}