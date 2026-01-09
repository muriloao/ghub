import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/auth_result.dart';
import '../entities/user.dart';
import '../entities/signup_request.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> signUp(SignUpRequest request);

  Future<Either<Failure, AuthResult>> loginWithCredentials({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResult>> loginWithGoogle();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, String?>> getAccessToken();
}
