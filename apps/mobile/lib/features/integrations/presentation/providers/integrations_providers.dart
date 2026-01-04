import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'integrations_notifier.dart';
import '../../domain/entities/gaming_platform.dart';

// Main integrations provider
final integrationsNotifierProvider =
    StateNotifierProvider<IntegrationsNotifier, IntegrationsState>((ref) {
      return IntegrationsNotifier();
    });

// Convenience providers for specific data
final integrationsListProvider = Provider<List<GamingPlatform>>((ref) {
  return ref.watch(integrationsNotifierProvider).platforms;
});

final connectedPlatformsProvider = Provider<List<GamingPlatform>>((ref) {
  return ref.watch(integrationsNotifierProvider).connectedPlatforms;
});

final disconnectedPlatformsProvider = Provider<List<GamingPlatform>>((ref) {
  return ref.watch(integrationsNotifierProvider).disconnectedPlatforms;
});

final connectionProgressProvider = Provider<double>((ref) {
  return ref.watch(integrationsNotifierProvider).connectionProgress;
});

final connectedCountProvider = Provider<int>((ref) {
  return ref.watch(integrationsNotifierProvider).connectedCount;
});

final isLoadingIntegrationsProvider = Provider<bool>((ref) {
  return ref.watch(integrationsNotifierProvider).isLoading;
});

final integrationsErrorProvider = Provider<String?>((ref) {
  return ref.watch(integrationsNotifierProvider).error;
});

// Provider for specific platform by ID
final platformByIdProvider = Provider.family<GamingPlatform?, String>((
  ref,
  platformId,
) {
  final platforms = ref.watch(integrationsListProvider);
  try {
    return platforms.firstWhere((platform) => platform.id == platformId);
  } catch (e) {
    return null;
  }
});
