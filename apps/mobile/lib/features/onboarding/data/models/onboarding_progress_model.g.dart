// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingProgressModel _$OnboardingProgressModelFromJson(
  Map<String, dynamic> json,
) => OnboardingProgressModel(
  platformModels: (json['platforms'] as List<dynamic>)
      .map((e) => GamingPlatformModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentStep: (json['current_step'] as num).toInt(),
  totalSteps: (json['total_steps'] as num).toInt(),
  isCompleted: json['is_completed'] as bool,
);

Map<String, dynamic> _$OnboardingProgressModelToJson(
  OnboardingProgressModel instance,
) => <String, dynamic>{
  'current_step': instance.currentStep,
  'total_steps': instance.totalSteps,
  'is_completed': instance.isCompleted,
  'platforms': instance.platformModels.map((e) => e.toJson()).toList(),
};
