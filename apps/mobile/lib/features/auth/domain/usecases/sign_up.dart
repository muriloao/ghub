import 'package:dartz/dartz.dart';
import 'package:ghub_mobile/core/error/failure.dart';
import '../entities/auth_result.dart';
import '../entities/signup_request.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, AuthResult>> call(SignUpRequest request) async {
    // Validações básicas
    if (request.gamertag.isEmpty) {
      return const Left(ValidationFailure('Gamertag é obrigatório'));
    }

    if (request.gamertag.length < 3) {
      return const Left(
        ValidationFailure('Gamertag deve ter pelo menos 3 caracteres'),
      );
    }

    if (request.gamertag.length > 20) {
      return const Left(
        ValidationFailure('Gamertag deve ter no máximo 20 caracteres'),
      );
    }

    if (!_isValidGamertag(request.gamertag)) {
      return const Left(
        ValidationFailure(
          'Gamertag deve conter apenas letras, números e underscore',
        ),
      );
    }

    if (request.email.isEmpty) {
      return const Left(ValidationFailure('Email é obrigatório'));
    }

    if (!_isValidEmail(request.email)) {
      return const Left(ValidationFailure('Email inválido'));
    }

    if (request.password.isEmpty) {
      return const Left(ValidationFailure('Senha é obrigatória'));
    }

    if (request.password.length < 6) {
      return const Left(
        ValidationFailure('Senha deve ter pelo menos 6 caracteres'),
      );
    }

    if (request.password != request.confirmPassword) {
      return const Left(ValidationFailure('Senhas não coincidem'));
    }

    if (!_isStrongPassword(request.password)) {
      return const Left(
        ValidationFailure(
          'Senha deve conter pelo menos uma letra maiúscula, minúscula e número',
        ),
      );
    }

    return await repository.signUp(request);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidGamertag(String gamertag) {
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(gamertag);
  }

  bool _isStrongPassword(String password) {
    // Pelo menos uma maiúscula, uma minúscula e um número
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password);
  }
}
