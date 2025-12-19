import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor para logging das requisições (apenas em modo debug)
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('🚀 REQUEST: ${options.method} ${options.uri}');
      if (options.data != null) {
        print('📦 DATA: ${options.data}');
      }
      if (options.headers.isNotEmpty) {
        print('📋 HEADERS: ${options.headers}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      print('📄 DATA: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('❌ ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
      print('💀 MESSAGE: ${err.message}');
      if (err.response != null) {
        print('📊 STATUS: ${err.response?.statusCode}');
        print('📄 DATA: ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}

/// Interceptor para adicionar tokens de autenticação
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: Implementar lógica para adicionar token de autenticação
    // Exemplo:
    // final token = getStoredToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }
}

/// Interceptor para tratamento de erros
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Timeout de conexão';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Timeout no envio da requisição';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Timeout no recebimento da resposta';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusError(err.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Requisição cancelada';
        break;
      default:
        errorMessage = 'Erro de conexão';
    }

    // Criar uma nova exceção com mensagem amigável
    final customError = DioException(
      requestOptions: err.requestOptions,
      message: errorMessage,
      type: err.type,
      response: err.response,
    );

    super.onError(customError, handler);
  }

  String _handleStatusError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requisição inválida';
      case 401:
        return 'Não autorizado';
      case 403:
        return 'Acesso negado';
      case 404:
        return 'Recurso não encontrado';
      case 422:
        return 'Dados inválidos';
      case 500:
        return 'Erro interno do servidor';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Serviço indisponível';
      default:
        return 'Erro no servidor ($statusCode)';
    }
  }
}
