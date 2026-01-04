import 'package:flutter/material.dart';

enum PlatformType {
  steam,
  xbox,
  playstation,
  epicGames,
  gogGalaxy,
  uplay,
  eaPlay,
  origin,
  battleNet,
  amazonGames,
}

enum ConnectionStatus { connected, disconnected, connecting }

class GamingPlatform {
  final String id;
  final String name;
  final String description;
  final PlatformType type;
  final ConnectionStatus status;
  final Color primaryColor;
  final Color backgroundColor;
  final IconData icon;
  final String? logoText;
  final List<String> features;
  final DateTime? connectedAt;
  final String? connectedUsername;

  const GamingPlatform({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.primaryColor,
    required this.backgroundColor,
    required this.icon,
    this.logoText,
    required this.features,
    this.connectedAt,
    this.connectedUsername,
  });

  GamingPlatform copyWith({
    String? id,
    String? name,
    String? description,
    PlatformType? type,
    ConnectionStatus? status,
    Color? primaryColor,
    Color? backgroundColor,
    IconData? icon,
    String? logoText,
    List<String>? features,
    DateTime? connectedAt,
    String? connectedUsername,
  }) {
    return GamingPlatform(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      icon: icon ?? this.icon,
      logoText: logoText ?? this.logoText,
      features: features ?? this.features,
      connectedAt: connectedAt ?? this.connectedAt,
      connectedUsername: connectedUsername ?? this.connectedUsername,
    );
  }

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isConnecting => status == ConnectionStatus.connecting;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GamingPlatform &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ type.hashCode ^ status.hashCode;
  }
}
