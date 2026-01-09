import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/onboarding_local_data_source.dart';
import '../../data/datasources/onboarding_remote_data_source.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/get_onboarding_progress.dart';
import '../../domain/usecases/connect_platform.dart';
import '../../domain/usecases/get_available_platforms.dart';
import '../../domain/usecases/complete_onboarding.dart';

// Import shared providers from auth
import '../../../auth/presentation/providers/auth_providers.dart';

// Data sources
final onboardingRemoteDataSourceProvider = Provider<OnboardingRemoteDataSource>(
  (ref) {
    return OnboardingRemoteDataSourceImpl(dio: ref.watch(dioProvider));
  },
);

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((
  ref,
) {
  return OnboardingLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

// Repository
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(
    remoteDataSource: ref.watch(onboardingRemoteDataSourceProvider),
    localDataSource: ref.watch(onboardingLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// Use cases
final getOnboardingProgressProvider = Provider<GetOnboardingProgress>((ref) {
  return GetOnboardingProgress(ref.watch(onboardingRepositoryProvider));
});

final connectPlatformProvider = Provider<ConnectPlatform>((ref) {
  return ConnectPlatform(ref.watch(onboardingRepositoryProvider));
});

final getAvailablePlatformsProvider = Provider<GetAvailablePlatforms>((ref) {
  return GetAvailablePlatforms(ref.watch(onboardingRepositoryProvider));
});

final completeOnboardingProvider = Provider<CompleteOnboarding>((ref) {
  return CompleteOnboarding(ref.watch(onboardingRepositoryProvider));
});

final skipOnboardingProvider = Provider<SkipOnboarding>((ref) {
  return SkipOnboarding(ref.watch(onboardingRepositoryProvider));
});
