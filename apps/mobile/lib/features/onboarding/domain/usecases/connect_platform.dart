import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/gaming_platform.dart';
import '../entities/platform_connection_request.dart';
import '../repositories/onboarding_repository.dart';

class ConnectPlatform
    implements UseCase<GamingPlatform, PlatformConnectionRequest> {
  final OnboardingRepository repository;

  ConnectPlatform(this.repository);

  @override
  Future<Either<Failure, GamingPlatform>> call(
    PlatformConnectionRequest params,
  ) async {
    return await repository.connectPlatform(params);
  }
}
