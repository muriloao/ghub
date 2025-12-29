import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/gaming_platform.dart';
import '../../domain/entities/onboarding_progress.dart';
import '../../domain/entities/platform_connection_request.dart';
import '../../domain/usecases/get_onboarding_progress.dart';
import '../../domain/usecases/connect_platform.dart';
import '../../domain/usecases/get_available_platforms.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../../../core/usecases/usecase.dart';
import 'onboarding_providers.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingLoaded extends OnboardingState {
  final OnboardingProgress progress;

  const OnboardingLoaded(this.progress);

  @override
  List<Object> get props => [progress];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object> get props => [message];
}

extension OnboardingStateX on OnboardingState {
  T when<T>({
    required T Function() loading,
    required T Function(OnboardingProgress progress) loaded,
    required T Function(String message) error,
  }) {
    if (this is OnboardingLoading) {
      return loading();
    } else if (this is OnboardingLoaded) {
      return loaded((this as OnboardingLoaded).progress);
    } else if (this is OnboardingError) {
      return error((this as OnboardingError).message);
    }
    throw Exception('Unknown state: $this');
  }

  T maybeWhen<T>({
    T Function()? loading,
    T Function(OnboardingProgress progress)? loaded,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    if (this is OnboardingLoading && loading != null) {
      return loading();
    } else if (this is OnboardingLoaded && loaded != null) {
      return loaded((this as OnboardingLoaded).progress);
    } else if (this is OnboardingError && error != null) {
      return error((this as OnboardingError).message);
    }
    return orElse();
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final GetOnboardingProgress _getOnboardingProgress;
  final ConnectPlatform _connectPlatform;
  final GetAvailablePlatforms _getAvailablePlatforms;
  final CompleteOnboarding _completeOnboarding;
  final SkipOnboarding _skipOnboarding;

  OnboardingNotifier({
    required GetOnboardingProgress getOnboardingProgress,
    required ConnectPlatform connectPlatform,
    required GetAvailablePlatforms getAvailablePlatforms,
    required CompleteOnboarding completeOnboarding,
    required SkipOnboarding skipOnboarding,
  }) : _getOnboardingProgress = getOnboardingProgress,
       _connectPlatform = connectPlatform,
       _getAvailablePlatforms = getAvailablePlatforms,
       _completeOnboarding = completeOnboarding,
       _skipOnboarding = skipOnboarding,
       super(const OnboardingLoading()) {
    _loadOnboardingProgress();
  }

  Future<void> _loadOnboardingProgress() async {
    state = const OnboardingLoading();

    final result = await _getOnboardingProgress(NoParams());
    result.fold((failure) {
      // Se falhar, criar um progresso padrão com plataformas
      _loadDefaultPlatforms();
    }, (progress) => state = OnboardingLoaded(progress));
  }

  Future<void> _loadDefaultPlatforms() async {
    // Criar plataformas padrão se não conseguir carregar do servidor
    final defaultPlatforms = [
      const GamingPlatform(
        type: PlatformType.steam,
        isConnected: true,
        username: 'user123',
      ),
      const GamingPlatform(
        type: PlatformType.xbox,
        isConnected: true,
        username: 'GamerTag',
      ),
      const GamingPlatform(type: PlatformType.playstation, isConnected: false),
      const GamingPlatform(type: PlatformType.epicGames, isConnected: false),
      const GamingPlatform(type: PlatformType.gog, isConnected: false),
    ];

    final progress = OnboardingProgress(
      platforms: defaultPlatforms,
      currentStep: 1,
      totalSteps: 3,
      isCompleted: false,
    );

    state = OnboardingLoaded(progress);
  }

  Future<void> connectPlatform(
    String platformId,
    Map<String, dynamic> credentials,
  ) async {
    final currentState = state;
    if (currentState is! OnboardingLoaded) return;

    final request = PlatformConnectionRequest(
      platformId: platformId,
      credentials: credentials,
    );

    final result = await _connectPlatform(request);
    result.fold(
      (failure) {
        // Para demo, simular conexão bem-sucedida
        _simulateConnection(platformId, currentState.progress);
      },
      (connectedPlatform) {
        final updatedPlatforms = currentState.progress.platforms.map((
          platform,
        ) {
          if (platform.type.name.toLowerCase() == platformId.toLowerCase()) {
            return platform.copyWith(
              isConnected: true,
              connectedAt: DateTime.now(),
            );
          }
          return platform;
        }).toList();

        final updatedProgress = currentState.progress.copyWith(
          platforms: updatedPlatforms,
        );

        state = OnboardingLoaded(updatedProgress);
      },
    );
  }

  void _simulateConnection(
    String platformId,
    OnboardingProgress currentProgress,
  ) {
    final updatedPlatforms = currentProgress.platforms.map((platform) {
      if (platform.type.name.toLowerCase() == platformId.toLowerCase()) {
        return platform.copyWith(
          isConnected: true,
          connectedAt: DateTime.now(),
        );
      }
      return platform;
    }).toList();

    final updatedProgress = currentProgress.copyWith(
      platforms: updatedPlatforms,
    );

    state = OnboardingLoaded(updatedProgress);
  }

  Future<void> completeOnboarding() async {
    final result = await _completeOnboarding(NoParams());
    result.fold((failure) => state = OnboardingError(failure.toString()), (_) {
      // Onboarding completed successfully
      final currentState = state;
      if (currentState is OnboardingLoaded) {
        final updatedProgress = currentState.progress.copyWith(
          isCompleted: true,
        );
        state = OnboardingLoaded(updatedProgress);
      }
    });
  }

  Future<void> skipOnboarding() async {
    final result = await _skipOnboarding(NoParams());
    result.fold((failure) => state = OnboardingError(failure.toString()), (_) {
      // Onboarding skipped successfully
      final currentState = state;
      if (currentState is OnboardingLoaded) {
        final updatedProgress = currentState.progress.copyWith(
          isCompleted: true,
        );
        state = OnboardingLoaded(updatedProgress);
      }
    });
  }

  Future<void> refresh() async {
    await _loadOnboardingProgress();
  }
}

final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
      return OnboardingNotifier(
        getOnboardingProgress: ref.watch(getOnboardingProgressProvider),
        connectPlatform: ref.watch(connectPlatformProvider),
        getAvailablePlatforms: ref.watch(getAvailablePlatformsProvider),
        completeOnboarding: ref.watch(completeOnboardingProvider),
        skipOnboarding: ref.watch(skipOnboardingProvider),
      );
    });
