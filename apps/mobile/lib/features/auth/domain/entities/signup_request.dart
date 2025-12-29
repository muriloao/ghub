import 'package:equatable/equatable.dart';

class SignUpRequest extends Equatable {
  final String gamertag;
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpRequest({
    required this.gamertag,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [gamertag, email, password, confirmPassword];
}
