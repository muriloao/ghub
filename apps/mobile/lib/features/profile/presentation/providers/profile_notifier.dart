import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/profile_entities.dart';

class ProfileState {
  final UserStats stats;
  final List<ConnectedPlatform> platforms;
  final List<Integration> integrations;
  final List<SettingItem> settings;
  final bool isLoading;
  final String? error;

  const ProfileState({
    required this.stats,
    required this.platforms,
    required this.integrations,
    required this.settings,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    UserStats? stats,
    List<ConnectedPlatform>? platforms,
    List<Integration>? integrations,
    List<SettingItem>? settings,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      stats: stats ?? this.stats,
      platforms: platforms ?? this.platforms,
      integrations: integrations ?? this.integrations,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(_getInitialState()) {
    _initializeProfile();
  }

  static ProfileState _getInitialState() {
    return ProfileState(
      stats: const UserStats(
        gamesCount: 0,
        trophiesCount: 0,
        totalPlayTime: '0h',
      ),
      platforms: [],
      integrations: [],
      settings: [],
      isLoading: true,
    );
  }

  void _initializeProfile() {
    final stats = _getUserStats();
    final platforms = _getConnectedPlatforms();
    final integrations = _getIntegrations();
    final settings = _getSettings();

    state = state.copyWith(
      stats: stats,
      platforms: platforms,
      integrations: integrations,
      settings: settings,
      isLoading: false,
    );
  }

  UserStats _getUserStats() {
    return const UserStats(
      gamesCount: 245,
      trophiesCount: 1200,
      totalPlayTime: '850h',
    );
  }

  List<ConnectedPlatform> _getConnectedPlatforms() {
    return [
      const ConnectedPlatform(
        id: 'steam',
        name: 'Steam',
        icon: Icons.sports_esports,
        backgroundColor: Color(0xFF171a21),
        isConnected: true,
        status: 'Connected',
      ),
      const ConnectedPlatform(
        id: 'playstation',
        name: 'PlayStation',
        icon: Icons.sports_esports,
        backgroundColor: Color(0xFF003791),
        isConnected: true,
        status: 'Connected',
      ),
      const ConnectedPlatform(
        id: 'xbox',
        name: 'Xbox',
        icon: Icons.add,
        backgroundColor: Color(0xFF107C10),
        isConnected: false,
        status: 'Link Account',
      ),
      const ConnectedPlatform(
        id: 'nintendo',
        name: 'Nintendo',
        icon: Icons.add,
        backgroundColor: Color(0xFFe60012),
        isConnected: false,
        status: 'Link Account',
      ),
    ];
  }

  List<Integration> _getIntegrations() {
    return [
      const Integration(
        id: 'nexus_mods',
        name: 'Nexus Mods',
        description: 'Auto-sync mod library',
        icon: Icons.extension,
        backgroundColor: Colors.orange,
        isActive: true,
      ),
    ];
  }

  List<SettingItem> _getSettings() {
    return [
      SettingItem(
        id: 'notifications',
        title: 'Notifications',
        icon: Icons.notifications,
        iconColor: Colors.blue,
        iconBackgroundColor: Colors.blue.withOpacity(0.1),
        type: SettingItemType.navigation,
        onTap: () => _handleNotificationsTap(),
      ),
      SettingItem(
        id: 'privacy',
        title: 'Privacy',
        icon: Icons.lock,
        iconColor: Colors.grey,
        iconBackgroundColor: Colors.grey.withOpacity(0.1),
        type: SettingItemType.navigation,
        onTap: () => _handlePrivacyTap(),
      ),
      SettingItem(
        id: 'sync',
        title: 'Sync Preferences',
        value: 'Auto',
        icon: Icons.sync,
        iconColor: Colors.green,
        iconBackgroundColor: Colors.green.withOpacity(0.1),
        type: SettingItemType.selection,
        onTap: () => _handleSyncTap(),
      ),
      SettingItem(
        id: 'wishlist',
        title: 'Wishlist Rules',
        icon: Icons.favorite,
        iconColor: Colors.pink,
        iconBackgroundColor: Colors.pink.withOpacity(0.1),
        type: SettingItemType.navigation,
        onTap: () => _handleWishlistTap(),
      ),
      SettingItem(
        id: 'language',
        title: 'Language',
        value: 'English',
        icon: Icons.translate,
        iconColor: Colors.purple,
        iconBackgroundColor: Colors.purple.withOpacity(0.1),
        type: SettingItemType.selection,
        onTap: () => _handleLanguageTap(),
      ),
    ];
  }

  void _handleNotificationsTap() {
    // TODO: Navigate to notifications settings
    print('Navigate to notifications settings');
  }

  void _handlePrivacyTap() {
    // TODO: Navigate to privacy settings
    print('Navigate to privacy settings');
  }

  void _handleSyncTap() {
    // TODO: Show sync preferences dialog
    print('Show sync preferences dialog');
  }

  void _handleWishlistTap() {
    // TODO: Navigate to wishlist rules
    print('Navigate to wishlist rules');
  }

  void _handleLanguageTap() {
    // TODO: Show language selection dialog
    print('Show language selection dialog');
  }

  void toggleIntegration(String integrationId) {
    final updatedIntegrations = state.integrations.map((integration) {
      if (integration.id == integrationId) {
        return integration.copyWith(isActive: !integration.isActive);
      }
      return integration;
    }).toList();

    state = state.copyWith(integrations: updatedIntegrations);
  }

  void connectPlatform(String platformId) {
    final updatedPlatforms = state.platforms.map((platform) {
      if (platform.id == platformId) {
        return platform.copyWith(isConnected: true, status: 'Connected');
      }
      return platform;
    }).toList();

    state = state.copyWith(platforms: updatedPlatforms);
  }

  void disconnectPlatform(String platformId) {
    final updatedPlatforms = state.platforms.map((platform) {
      if (platform.id == platformId) {
        return platform.copyWith(isConnected: false, status: 'Link Account');
      }
      return platform;
    }).toList();

    state = state.copyWith(platforms: updatedPlatforms);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
