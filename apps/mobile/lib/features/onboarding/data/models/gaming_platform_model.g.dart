// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaming_platform_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamingPlatformModel _$GamingPlatformModelFromJson(Map<String, dynamic> json) =>
    GamingPlatformModel(
      platformTypeName: json['platform_type'] as String,
      isConnected: json['is_connected'] as bool,
      username: json['username'] as String?,
      connectedAt: json['connected_at'] == null
          ? null
          : DateTime.parse(json['connected_at'] as String),
    );

Map<String, dynamic> _$GamingPlatformModelToJson(
  GamingPlatformModel instance,
) => <String, dynamic>{
  'is_connected': instance.isConnected,
  'username': instance.username,
  'connected_at': instance.connectedAt?.toIso8601String(),
  'platform_type': instance.platformTypeName,
};
