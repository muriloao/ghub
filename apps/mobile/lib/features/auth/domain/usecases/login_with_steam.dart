import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginWithSteam {
  final AuthRepository repository;

  LoginWithSteam(this.repository);

  Future<Either<Failure, AuthResult>> call() async {
    return await repository.loginWithSteam();
  }
}
