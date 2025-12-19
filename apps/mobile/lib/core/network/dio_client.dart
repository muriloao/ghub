import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ghub_mobile/core/network/interceptors.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(DioClientRef ref) {
  final dio = Dio();

  // Configuração base
  dio.options = BaseOptions(
    baseUrl: 'https://api.github.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'ghub-mobile-app',
    },
  );

  // Adicionar interceptors
  dio.interceptors.addAll([
    LoggingInterceptor(),
    AuthInterceptor(),
    ErrorInterceptor(),
  ]);

  return dio;
}
