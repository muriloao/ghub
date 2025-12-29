// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_connection_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformConnectionRequestModel _$PlatformConnectionRequestModelFromJson(
  Map<String, dynamic> json,
) => PlatformConnectionRequestModel(
  platformId: json['platform_id'] as String,
  credentials: json['credentials'] as Map<String, dynamic>,
);

Map<String, dynamic> _$PlatformConnectionRequestModelToJson(
  PlatformConnectionRequestModel instance,
) => <String, dynamic>{
  'platform_id': instance.platformId,
  'credentials': instance.credentials,
};
