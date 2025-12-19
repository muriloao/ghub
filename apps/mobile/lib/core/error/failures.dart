import 'package:equatable/equatable.dart';

/// Classe base para todas as falhas da aplicação
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Falha de conexão/rede
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Falha de autenticação
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Falha de validação
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Falha no servidor
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Falha de cache
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Falha genérica
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
