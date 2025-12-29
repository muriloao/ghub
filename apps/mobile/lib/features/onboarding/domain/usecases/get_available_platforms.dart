import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/gaming_platform.dart';
import '../repositories/onboarding_repository.dart';

class GetAvailablePlatforms implements UseCase<List<GamingPlatform>, NoParams> {
  final OnboardingRepository repository;

  GetAvailablePlatforms(this.repository);

  @override
  Future<Either<Failure, List<GamingPlatform>>> call(NoParams params) async {
    return await repository.getAvailablePlatforms();
  }
}
