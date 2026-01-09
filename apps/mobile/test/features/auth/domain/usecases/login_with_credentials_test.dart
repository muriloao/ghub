import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/core/error/failure.dart';
import 'package:ghub_mobile/features/auth/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:ghub_mobile/features/auth/domain/usecases/login_with_credentials.dart';
import 'package:ghub_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:ghub_mobile/features/auth/domain/entities/auth_result.dart';

import '../../../../helpers/test_helpers.dart';
@GenerateMocks([AuthRepository])
import 'logout_test.mocks.dart';

void main() {
  late LoginWithCredentials usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginWithCredentials(mockAuthRepository);
  });

  group('LoginWithCredentials', () {
    const validEmail = TestFixtures.validEmail;
    const validPassword = TestFixtures.validPassword;
    const invalidEmail = TestFixtures.invalidEmail;
    const shortPassword = TestFixtures.shortPassword;

    final authResult = AuthResult(
      user: User.fromJson(TestFixtures.userJson),
      accessToken: TestFixtures.accessToken,
      refreshToken: TestFixtures.refreshToken,
    );

    test('should return AuthResult when login is successful', () async {
      // arrange
      when(
        mockAuthRepository.loginWithCredentials(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Right(authResult));

      // act
      final result = await usecase(email: validEmail, password: validPassword);

      // assert
      expect(result, Right(authResult));
      verify(
        mockAuthRepository.loginWithCredentials(
          email: validEmail,
          password: validPassword,
        ),
      );
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when email is empty', () async {
      // act
      final result = await usecase(email: '', password: validPassword);

      // assert
      expect(
        result,
        const Left(ValidationFailure('Email e senha são obrigatórios')),
      );
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when password is empty', () async {
      // act
      final result = await usecase(email: validEmail, password: '');

      // assert
      expect(
        result,
        const Left(ValidationFailure('Email e senha são obrigatórios')),
      );
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when email is invalid', () async {
      // act
      final result = await usecase(
        email: invalidEmail,
        password: validPassword,
      );

      // assert
      expect(result, const Left(ValidationFailure('Email inválido')));
      verifyZeroInteractions(mockAuthRepository);
    });

    test(
      'should return ValidationFailure when password is too short',
      () async {
        // act
        final result = await usecase(
          email: validEmail,
          password: shortPassword,
        );

        // assert
        expect(
          result,
          const Left(
            ValidationFailure('Senha deve ter pelo menos 6 caracteres'),
          ),
        );
        verifyZeroInteractions(mockAuthRepository);
      },
    );

    test('should return ServerFailure when repository fails', () async {
      // arrange
      when(
        mockAuthRepository.loginWithCredentials(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // act
      final result = await usecase(email: validEmail, password: validPassword);

      // assert
      expect(result, const Left(ServerFailure('Server error')));
      verify(
        mockAuthRepository.loginWithCredentials(
          email: validEmail,
          password: validPassword,
        ),
      );
    });
  });
}
