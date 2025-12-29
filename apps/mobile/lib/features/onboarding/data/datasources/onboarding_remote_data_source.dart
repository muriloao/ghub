import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/gaming_platform_model.dart';
import '../models/onboarding_progress_model.dart';
import '../models/platform_connection_request_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<OnboardingProgressModel> getOnboardingProgress();
  Future<GamingPlatformModel> connectPlatform(
    PlatformConnectionRequestModel request,
  );
  Future<void> disconnectPlatform(String platformId);
  Future<void> skipOnboarding();
  Future<void> completeOnboarding();
  Future<List<GamingPlatformModel>> getAvailablePlatforms();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final Dio dio;

  OnboardingRemoteDataSourceImpl({required this.dio});

  @override
  Future<OnboardingProgressModel> getOnboardingProgress() async {
    try {
      final response = await dio.get('/onboarding/progress');
      return OnboardingProgressModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  @override
  Future<GamingPlatformModel> connectPlatform(
    PlatformConnectionRequestModel request,
  ) async {
    try {
      final response = await dio.post(
        '/onboarding/connect-platform',
        data: request.toServerJson(),
      );
      return GamingPlatformModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  @override
  Future<void> disconnectPlatform(String platformId) async {
    try {
      await dio.delete('/onboarding/disconnect-platform/$platformId');
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  @override
  Future<void> skipOnboarding() async {
    try {
      await dio.post('/onboarding/skip');
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  @override
  Future<void> completeOnboarding() async {
    try {
      await dio.post('/onboarding/complete');
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  @override
  Future<List<GamingPlatformModel>> getAvailablePlatforms() async {
    try {
      final response = await dio.get('/onboarding/available-platforms');
      final List<dynamic> platformsList = response.data['platforms'];
      return platformsList
          .map((json) => GamingPlatformModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unknown error';
        return 'Server error ($statusCode): $message';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.unknown:
        return 'Unknown error: ${error.message}';
      default:
        return 'Network error';
    }
  }
}
