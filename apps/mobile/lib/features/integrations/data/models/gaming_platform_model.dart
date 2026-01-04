import 'package:flutter/material.dart';

import '../../domain/entities/gaming_platform.dart';

class GamingPlatformModel extends GamingPlatform {
  const GamingPlatformModel({
    required super.id,
    required super.name,
    required super.description,
    required super.type,
    required super.status,
    required super.primaryColor,
    required super.backgroundColor,
    required super.icon,
    super.logoText,
    required super.features,
    super.connectedAt,
    super.connectedUsername,
  });

  factory GamingPlatformModel.fromJson(Map<String, dynamic> json) {
    return GamingPlatformModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: PlatformType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PlatformType.steam,
      ),
      status: ConnectionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ConnectionStatus.disconnected,
      ),
      primaryColor: const Color(0xFFe225f4), // Will be set from constants
      backgroundColor: const Color(0xFF211022), // Will be set from constants
      icon: const IconData(0xe30d), // Generic gaming icon
      logoText: json['logoText'] as String?,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      connectedAt: json['connectedAt'] != null
          ? DateTime.parse(json['connectedAt'] as String)
          : null,
      connectedUsername: json['connectedUsername'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'status': status.name,
      'logoText': logoText,
      'features': features,
      'connectedAt': connectedAt?.toIso8601String(),
      'connectedUsername': connectedUsername,
    };
  }

  @override
  GamingPlatformModel copyWith({
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
    return GamingPlatformModel(
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
}
