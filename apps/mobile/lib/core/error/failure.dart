import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  @override
  String toString() => 'ServerFailure: $message';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);

  @override
  String toString() => 'CacheFailure: $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);

  @override
  String toString() => 'NetworkFailure: $message';
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);

  @override
  String toString() => 'AuthenticationFailure: $message';
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);

  @override
  String toString() => 'ValidationFailure: $message';
}
