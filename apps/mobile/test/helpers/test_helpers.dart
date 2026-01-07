import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Mock classes for testing
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDio extends Mock implements Dio {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

// Helper function to create ProviderContainer with mocked dependencies
ProviderContainer createMockContainer({
  SharedPreferences? mockSharedPreferences,
  FlutterSecureStorage? mockSecureStorage,
  Dio? mockDio,
  GoogleSignIn? mockGoogleSignIn,
}) {
  return ProviderContainer(
    overrides: [
      if (mockSharedPreferences != null)
        Provider<SharedPreferences>((ref) => mockSharedPreferences),
      if (mockSecureStorage != null)
        Provider<FlutterSecureStorage>((ref) => mockSecureStorage),
      if (mockDio != null)
        Provider<Dio>((ref) => mockDio),
      if (mockGoogleSignIn != null)
        Provider<GoogleSignIn>((ref) => mockGoogleSignIn),
    ],
  );
}

// Test fixtures and constants
class TestFixtures {
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'password123';
  static const String invalidEmail = 'invalid-email';
  static const String shortPassword = '123';
  
  static const String userId = 'test-user-id';
  static const String userName = 'Test User';
  static const String userAvatarUrl = 'https://example.com/avatar.jpg';
  
  static const String accessToken = 'test-access-token';
  static const String refreshToken = 'test-refresh-token';
  
  static const String steamId = '76561198000000000';
  static const String epicAccountId = 'epic-account-id';
  static const String xboxGamertag = 'TestGamertag';
  
  static Map<String, dynamic> userJson = {
    'id': userId,
    'email': validEmail,
    'name': userName,
    'avatar_url': userAvatarUrl,
    'created_at': '2024-01-01T00:00:00Z',
    'updated_at': '2024-01-01T00:00:00Z',
  };
  
  static Map<String, dynamic> authResultJson = {
    'user': userJson,
    'access_token': accessToken,
    'refresh_token': refreshToken,
  };
  
  static Map<String, dynamic> gameJson = {
    'id': 'game-id',
    'name': 'Test Game',
    'platform': 'steam',
    'app_id': '12345',
    'image_url': 'https://example.com/game.jpg',
    'playtime_hours': 10.5,
    'last_played': '2024-01-01T00:00:00Z',
  };
}

// Response helpers for HTTP mocks
class MockResponses {
  static Response<Map<String, dynamic>> successResponse(Map<String, dynamic> data) {
    return Response<Map<String, dynamic>>(
      data: data,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  static Response<List<Map<String, dynamic>>> successListResponse(List<Map<String, dynamic>> data) {
    return Response<List<Map<String, dynamic>>>(
      data: data,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
  
  static DioException unauthorizedError() {
    return DioException(
      requestOptions: RequestOptions(path: ''),
      response: Response(
        statusCode: 401,
        data: {'message': 'Unauthorized'},
        requestOptions: RequestOptions(path: ''),
      ),
    );
  }
  
  static DioException serverError() {
    return DioException(
      requestOptions: RequestOptions(path: ''),
      response: Response(
        statusCode: 500,
        data: {'message': 'Internal Server Error'},
        requestOptions: RequestOptions(path: ''),
      ),
    );
  }
  
  static DioException networkError() {
    return DioException(
      requestOptions: RequestOptions(path: ''),
      type: DioExceptionType.connectionTimeout,
      message: 'Connection timeout',
    );
  }
}