import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class LoginWithSteam {
  final AuthRepository repository;

  LoginWithSteam(this.repository);

  Future<void> call(BuildContext context) async {
    return await repository.loginWithSteam(context);
  }
}
