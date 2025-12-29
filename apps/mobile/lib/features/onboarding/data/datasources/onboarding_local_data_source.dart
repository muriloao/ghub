import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/onboarding_progress_model.dart';

abstract class OnboardingLocalDataSource {
  Future<OnboardingProgressModel?> getCachedOnboardingProgress();
  Future<void> cacheOnboardingProgress(OnboardingProgressModel progress);
  Future<void> markOnboardingCompleted();
  Future<bool> isOnboardingCompleted();
  Future<void> clearOnboardingCache();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _onboardingProgressKey = 'CACHED_ONBOARDING_PROGRESS';
  static const String _onboardingCompletedKey = 'ONBOARDING_COMPLETED';

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<OnboardingProgressModel?> getCachedOnboardingProgress() async {
    try {
      final jsonString = sharedPreferences.getString(_onboardingProgressKey);
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return OnboardingProgressModel.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cached onboarding progress: $e',
      );
    }
  }

  @override
  Future<void> cacheOnboardingProgress(OnboardingProgressModel progress) async {
    try {
      final jsonString = json.encode(progress.toJson());
      await sharedPreferences.setString(_onboardingProgressKey, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to cache onboarding progress: $e');
    }
  }

  @override
  Future<void> markOnboardingCompleted() async {
    try {
      await sharedPreferences.setBool(_onboardingCompletedKey, true);
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark onboarding as completed: $e',
      );
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      return sharedPreferences.getBool(_onboardingCompletedKey) ?? false;
    } catch (e) {
      throw CacheException(
        message: 'Failed to check if onboarding is completed: $e',
      );
    }
  }

  @override
  Future<void> clearOnboardingCache() async {
    try {
      await sharedPreferences.remove(_onboardingProgressKey);
      await sharedPreferences.remove(_onboardingCompletedKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear onboarding cache: $e');
    }
  }
}
