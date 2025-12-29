import 'package:equatable/equatable.dart';
import 'gaming_platform.dart';

class OnboardingProgress extends Equatable {
  final List<GamingPlatform> platforms;
  final int currentStep;
  final int totalSteps;
  final bool isCompleted;

  const OnboardingProgress({
    required this.platforms,
    required this.currentStep,
    required this.totalSteps,
    required this.isCompleted,
  });

  int get connectedPlatformsCount =>
      platforms.where((platform) => platform.isConnected).length;

  double get completionPercentage => connectedPlatformsCount / platforms.length;

  OnboardingProgress copyWith({
    List<GamingPlatform>? platforms,
    int? currentStep,
    int? totalSteps,
    bool? isCompleted,
  }) {
    return OnboardingProgress(
      platforms: platforms ?? this.platforms,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [platforms, currentStep, totalSteps, isCompleted];
}
