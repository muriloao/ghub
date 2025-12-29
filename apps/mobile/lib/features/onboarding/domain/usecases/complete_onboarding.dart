import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

class SkipOnboarding implements UseCase<void, NoParams> {
  final OnboardingRepository repository;

  SkipOnboarding(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.skipOnboarding();
  }
}

class CompleteOnboarding implements UseCase<void, NoParams> {
  final OnboardingRepository repository;

  CompleteOnboarding(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.completeOnboarding();
  }
}
