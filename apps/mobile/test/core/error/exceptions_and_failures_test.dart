import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/core/error/exceptions.dart';
import 'package:ghub_mobile/core/error/failures.dart';

void main() {
  group('Exceptions', () {
    group('ServerException', () {
      test('should create exception with message', () {
        // arrange
        const message = 'Server error occurred';
        
        // act
        const exception = ServerException(message: message);
        
        // assert
        expect(exception.message, message);
        expect(exception.toString(), 'ServerException: $message');
      });

      test('should support equality', () {
        // arrange
        const exception1 = ServerException(message: 'Error');
        const exception2 = ServerException(message: 'Error');
        const differentException = ServerException(message: 'Different Error');
        
        // assert
        expect(exception1, equals(exception2));
        expect(exception1, isNot(equals(differentException)));
      });
    });

    group('CacheException', () {
      test('should create exception with message', () {
        // arrange
        const message = 'Cache error occurred';
        
        // act
        const exception = CacheException(message: message);
        
        // assert
        expect(exception.message, message);
        expect(exception.toString(), 'CacheException: $message');
      });
    });

    group('AuthenticationException', () {
      test('should create exception with message', () {
        // arrange
        const message = 'Authentication failed';
        
        // act
        const exception = AuthenticationException(message: message);
        
        // assert
        expect(exception.message, message);
        expect(exception.toString(), 'AuthenticationException: $message');
      });
    });

    group('NetworkException', () {
      test('should create exception with message', () {
        // arrange
        const message = 'Network error occurred';
        
        // act
        const exception = NetworkException(message: message);
        
        // assert
        expect(exception.message, message);
        expect(exception.toString(), 'NetworkException: $message');
      });
    });

    group('ValidationException', () {
      test('should create exception with message', () {
        // arrange
        const message = 'Validation failed';
        
        // act
        const exception = ValidationException(message: message);
        
        // assert
        expect(exception.message, message);
        expect(exception.toString(), 'ValidationException: $message');
      });
    });
  });

  group('Failures', () {
    group('ServerFailure', () {
      test('should create failure with message', () {
        // arrange
        const message = 'Server failure occurred';
        
        // act
        const failure = ServerFailure(message: message);
        
        // assert
        expect(failure.message, message);
        expect(failure.toString(), 'ServerFailure: $message');
      });

      test('should support equality', () {
        // arrange
        const failure1 = ServerFailure(message: 'Error');
        const failure2 = ServerFailure(message: 'Error');
        const differentFailure = ServerFailure(message: 'Different Error');
        
        // assert
        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(differentFailure)));
      });
    });

    group('CacheFailure', () {
      test('should create failure with message', () {
        // arrange
        const message = 'Cache failure occurred';
        
        // act
        const failure = CacheFailure(message: message);
        
        // assert
        expect(failure.message, message);
        expect(failure.toString(), 'CacheFailure: $message');
      });
    });

    group('AuthenticationFailure', () {
      test('should create failure with message', () {
        // arrange
        const message = 'Authentication failure occurred';
        
        // act
        const failure = AuthenticationFailure(message: message);
        
        // assert
        expect(failure.message, message);
        expect(failure.toString(), 'AuthenticationFailure: $message');
      });
    });

    group('NetworkFailure', () {
      test('should create failure with message', () {
        // arrange
        const message = 'Network failure occurred';
        
        // act
        const failure = NetworkFailure(message: message);
        
        // assert
        expect(failure.message, message);
        expect(failure.toString(), 'NetworkFailure: $message');
      });
    });

    group('ValidationFailure', () {
      test('should create failure with message', () {
        // arrange
        const message = 'Validation failure occurred';
        
        // act
        const failure = ValidationFailure(message: message);
        
        // assert
        expect(failure.message, message);
        expect(failure.toString(), 'ValidationFailure: $message');
      });
    });
  });
}