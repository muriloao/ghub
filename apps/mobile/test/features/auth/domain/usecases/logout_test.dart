import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:ghub_mobile/features/auth/domain/usecases/logout.dart';
import 'package:ghub_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:ghub_mobile/core/error/failure.dart';

@GenerateMocks([AuthRepository])
import 'logout_test.mocks.dart';

void main() {
  late Logout usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Logout(mockAuthRepository);
  });

  group('Logout', () {
    test('should return Right(null) when logout is successful', () async {
      // arrange
      when(
        mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase();

      // assert
      expect(result, const Right(null));
      verify(mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return CacheFailure when logout fails', () async {
      // arrange
      when(mockAuthRepository.logout()).thenAnswer(
        (_) async => const Left(CacheFailure('Failed to clear cache')),
      );

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(CacheFailure('Failed to clear cache')));
      verify(mockAuthRepository.logout());
    });
  });
}
