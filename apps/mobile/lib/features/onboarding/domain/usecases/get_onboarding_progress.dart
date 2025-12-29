import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/onboarding_progress.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingProgress implements UseCase<OnboardingProgress, NoParams> {
  final OnboardingRepository repository;

  GetOnboardingProgress(this.repository);

  @override
  Future<Either<Failure, OnboardingProgress>> call(NoParams params) async {
    return await repository.getOnboardingProgress();
  }
}
