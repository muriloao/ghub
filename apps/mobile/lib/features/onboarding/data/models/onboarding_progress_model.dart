import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/onboarding_progress.dart';
import 'gaming_platform_model.dart';

part 'onboarding_progress_model.g.dart';

@JsonSerializable()
class OnboardingProgressModel extends OnboardingProgress {
  @JsonKey(name: 'platforms')
  final List<GamingPlatformModel> platformModels;

  const OnboardingProgressModel({
    required this.platformModels,
    required int currentStep,
    required int totalSteps,
    required bool isCompleted,
  }) : super(
         platforms: platformModels,
         currentStep: currentStep,
         totalSteps: totalSteps,
         isCompleted: isCompleted,
       );

  factory OnboardingProgressModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingProgressModelToJson(this);

  factory OnboardingProgressModel.fromDomain(OnboardingProgress progress) {
    return OnboardingProgressModel(
      platformModels: progress.platforms
          .map((platform) => GamingPlatformModel.fromDomain(platform))
          .toList(),
      currentStep: progress.currentStep,
      totalSteps: progress.totalSteps,
      isCompleted: progress.isCompleted,
    );
  }

  Map<String, dynamic> toServerJson() {
    return {
      'platforms': platformModels
          .map((platform) => platform.toServerJson())
          .toList(),
      'current_step': currentStep,
      'total_steps': totalSteps,
      'is_completed': isCompleted,
    };
  }
}
