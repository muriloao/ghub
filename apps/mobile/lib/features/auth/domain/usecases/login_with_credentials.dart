import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginWithCredentials {
  final AuthRepository repository;

  LoginWithCredentials(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String email,
    required String password,
  }) async {
    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Email e senha são obrigatórios'),
      );
    }

    if (!_isValidEmail(email)) {
      return const Left(ValidationFailure(message: 'Email inválido'));
    }

    if (password.length < 6) {
      return const Left(
        ValidationFailure(message: 'Senha deve ter pelo menos 6 caracteres'),
      );
    }

    return await repository.loginWithCredentials(
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
