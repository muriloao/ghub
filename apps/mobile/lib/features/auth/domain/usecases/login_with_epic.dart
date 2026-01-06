import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class LoginWithEpic {
  final AuthRepository repository;

  LoginWithEpic(this.repository);

  Future<void> call(BuildContext context) async {
    return await repository.loginWithEpic(context);
  }
}
