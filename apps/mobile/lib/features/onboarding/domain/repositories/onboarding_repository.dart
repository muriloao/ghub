import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/gaming_platform.dart';
import '../entities/onboarding_progress.dart';
import '../entities/platform_connection_request.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, OnboardingProgress>> getOnboardingProgress();
  Future<Either<Failure, GamingPlatform>> connectPlatform(
    PlatformConnectionRequest request,
  );
  Future<Either<Failure, void>> disconnectPlatform(String platformId);
  Future<Either<Failure, void>> skipOnboarding();
  Future<Either<Failure, void>> completeOnboarding();
  Future<Either<Failure, List<GamingPlatform>>> getAvailablePlatforms();
}
