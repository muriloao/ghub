import 'package:flutter/material.dart';

enum SettingItemType { navigation, toggle, selection }

class UserStats {
  final int gamesCount;
  final int trophiesCount;
  final String totalPlayTime;

  const UserStats({
    required this.gamesCount,
    required this.trophiesCount,
    required this.totalPlayTime,
  });

  UserStats copyWith({
    int? gamesCount,
    int? trophiesCount,
    String? totalPlayTime,
  }) {
    return UserStats(
      gamesCount: gamesCount ?? this.gamesCount,
      trophiesCount: trophiesCount ?? this.trophiesCount,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
    );
  }
}

class ConnectedPlatform {
  final String id;
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final bool isConnected;
  final String status;

  const ConnectedPlatform({
    required this.id,
    required this.name,
    required this.icon,
    required this.backgroundColor,
    required this.isConnected,
    required this.status,
  });

  ConnectedPlatform copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? backgroundColor,
    bool? isConnected,
    String? status,
  }) {
    return ConnectedPlatform(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isConnected: isConnected ?? this.isConnected,
      status: status ?? this.status,
    );
  }
}

class SettingItem {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final SettingItemType type;
  final String? value;
  final bool? isToggled;
  final VoidCallback? onTap;

  const SettingItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.type,
    this.value,
    this.isToggled,
    this.onTap,
  });

  SettingItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    SettingItemType? type,
    String? value,
    bool? isToggled,
    VoidCallback? onTap,
  }) {
    return SettingItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      type: type ?? this.type,
      value: value ?? this.value,
      isToggled: isToggled ?? this.isToggled,
      onTap: onTap ?? this.onTap,
    );
  }
}

class Integration {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final bool isActive;

  const Integration({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.backgroundColor,
    required this.isActive,
  });

  Integration copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? backgroundColor,
    bool? isActive,
  }) {
    return Integration(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isActive: isActive ?? this.isActive,
    );
  }
}
