import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_notifier.dart';
import '../../domain/entities/profile_entities.dart';

// Main profile provider
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      return ProfileNotifier();
    });

// Convenience providers for specific data
final userStatsProvider = Provider<UserStats>((ref) {
  return ref.watch(profileNotifierProvider).stats;
});

final connectedPlatformsProvider = Provider<List<ConnectedPlatform>>((ref) {
  return ref.watch(profileNotifierProvider).platforms;
});

final integrationsProvider = Provider<List<Integration>>((ref) {
  return ref.watch(profileNotifierProvider).integrations;
});

final settingsProvider = Provider<List<SettingItem>>((ref) {
  return ref.watch(profileNotifierProvider).settings;
});

final isLoadingProfileProvider = Provider<bool>((ref) {
  return ref.watch(profileNotifierProvider).isLoading;
});

final profileErrorProvider = Provider<String?>((ref) {
  return ref.watch(profileNotifierProvider).error;
});

// Provider for active connected platforms only
final activeConnectedPlatformsProvider = Provider<List<ConnectedPlatform>>((
  ref,
) {
  final platforms = ref.watch(connectedPlatformsProvider);
  return platforms.where((platform) => platform.isConnected).toList();
});

// Provider for available platforms to connect
final availablePlatformsProvider = Provider<List<ConnectedPlatform>>((ref) {
  final platforms = ref.watch(connectedPlatformsProvider);
  return platforms.where((platform) => !platform.isConnected).toList();
});

// Provider for active integrations
final activeIntegrationsProvider = Provider<List<Integration>>((ref) {
  final integrations = ref.watch(integrationsProvider);
  return integrations.where((integration) => integration.isActive).toList();
});
