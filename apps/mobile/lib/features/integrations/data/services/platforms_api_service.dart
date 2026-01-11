import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/platform_api_model.dart';
import '../../../../core/network/dio_client.dart';

class PlatformsApiService {
  final Dio _dio;

  PlatformsApiService(this._dio);

  /// Gets all available platforms from the API
  Future<PlatformsListResponse> getAvailablePlatforms() async {
    try {
      final response = await _dio.get('/platforms/available');
      return PlatformsListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch platforms: $e');
    }
  }

  /// Gets only enabled platforms from the API
  Future<PlatformsListResponse> getEnabledPlatforms() async {
    try {
      final response = await _dio.get('/platforms/enabled');
      return PlatformsListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch enabled platforms: $e');
    }
  }

  /// Gets all platforms from the API
  Future<PlatformsListResponse> getAllPlatforms() async {
    try {
      final response = await _dio.get('/platforms');
      return PlatformsListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch all platforms: $e');
    }
  }

  /// Gets a specific platform by ID
  Future<PlatformApiModel> getPlatformById(String id) async {
    try {
      final response = await _dio.get('/platforms/$id');
      return PlatformApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch platform $id: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.connectionError:
        return Exception(
          'No internet connection. Please check your connection.',
        );
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      default:
        return Exception('Network error: ${error.message}');
    }
  }
}

// Riverpod provider for the service
final platformsApiServiceProvider = Provider<PlatformsApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return PlatformsApiService(dio);
});
