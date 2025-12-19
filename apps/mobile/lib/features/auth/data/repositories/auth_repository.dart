import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ghub_mobile/core/error/failures.dart';
import 'package:ghub_mobile/core/network/dio_client.dart';
import 'package:ghub_mobile/features/auth/data/models/user_model.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepository(dio);
}

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  /// Autentica o usuário com token do GitHub
  Future<Either<Failure, UserModel>> authenticateWithToken(String token) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/user',
        options: Options(
          headers: {
            'Authorization': 'token $token',
          },
        ),
      );

      final user = UserModel.fromJson(response.data!);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Busca informações do usuário atual
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/user');
      final user = UserModel.fromJson(response.data!);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Faz logout removendo o token
  Future<void> logout() async {
    // TODO: Implementar lógica para remover token armazenado
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('Erro de conexão: ${error.message}');
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          return AuthFailure('Token inválido ou expirado');
        }
        return ServerFailure('Erro do servidor: ${error.response?.statusCode}');
      default:
        return NetworkFailure('Erro de rede: ${error.message}');
    }
  }
}
