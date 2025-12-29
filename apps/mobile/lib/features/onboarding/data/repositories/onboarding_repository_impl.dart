import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/gaming_platform.dart';
import '../../domain/entities/onboarding_progress.dart';
import '../../domain/entities/platform_connection_request.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';
import '../datasources/onboarding_remote_data_source.dart';
import '../models/gaming_platform_model.dart';
import '../models/onboarding_progress_model.dart';
import '../models/platform_connection_request_model.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;
  final OnboardingLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OnboardingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OnboardingProgress>> getOnboardingProgress() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProgress = await remoteDataSource.getOnboardingProgress();
        await localDataSource.cacheOnboardingProgress(remoteProgress);
        return Right(remoteProgress);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cachedProgress = await localDataSource
            .getCachedOnboardingProgress();
        if (cachedProgress != null) {
          return Right(cachedProgress);
        } else {
          return Left(CacheFailure('No cached data available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, GamingPlatform>> connectPlatform(
    PlatformConnectionRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final requestModel = PlatformConnectionRequestModel.fromDomain(request);
        final connectedPlatform = await remoteDataSource.connectPlatform(
          requestModel,
        );
        return Right(connectedPlatform);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectPlatform(String platformId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.disconnectPlatform(platformId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> skipOnboarding() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.skipOnboarding();
        await localDataSource.markOnboardingCompleted();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        await localDataSource.markOnboardingCompleted();
        return const Right(null);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.completeOnboarding();
        await localDataSource.markOnboardingCompleted();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        await localDataSource.markOnboardingCompleted();
        return const Right(null);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<GamingPlatform>>> getAvailablePlatforms() async {
    if (await networkInfo.isConnected) {
      try {
        final platforms = await remoteDataSource.getAvailablePlatforms();
        return Right(platforms);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }
}
