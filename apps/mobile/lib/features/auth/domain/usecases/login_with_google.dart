import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  Future<Either<Failure, AuthResult>> call() async {
    return await repository.loginWithGoogle();
  }
}
