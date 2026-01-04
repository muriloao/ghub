import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_result_model.dart';
import '../models/signup_request_model.dart';
import '../services/steam_auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResultModel> signUp(SignUpRequestModel request);

  Future<AuthResultModel> loginWithCredentials({
    required String email,
    required String password,
  });

  Future<AuthResultModel> loginWithGoogle();

  Future<void> loginWithSteam(BuildContext context);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final GoogleSignIn googleSignIn;
  late final SteamAuthService steamAuthService;

  AuthRemoteDataSourceImpl({required this.dio, required this.googleSignIn}) {
    steamAuthService = SteamAuthService(dio);
  }

  @override
  Future<AuthResultModel> signUp(SignUpRequestModel request) async {
    try {
      final response = await dio.post(
        '/auth/signup',
        data: request.toServerJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResultModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Cadastro falhou');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw const AuthenticationException(
          message: 'Email ou gamertag já existe',
        );
      } else if (e.response?.statusCode == 400) {
        throw AuthenticationException(
          message: e.response?.data['message'] ?? 'Dados inválidos',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException(message: 'Timeout de conexão');
      } else {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Erro no servidor',
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> loginWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return AuthResultModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthenticationException(message: 'Credenciais inválidas');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException(message: 'Timeout de conexão');
      } else {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Erro no servidor',
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthenticationException(
          message: 'Login com Google cancelado',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final response = await dio.post(
        '/auth/google',
        data: {
          'accessToken': googleAuth.accessToken,
          'idToken': googleAuth.idToken,
        },
      );

      if (response.statusCode == 200) {
        return AuthResultModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Login com Google failed');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro no servidor',
      );
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> loginWithSteam(BuildContext context) async {
    try {
      await steamAuthService.authenticateWithSteam(context);
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
      await googleSignIn.signOut();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao fazer logout',
      );
    }
  }
}
