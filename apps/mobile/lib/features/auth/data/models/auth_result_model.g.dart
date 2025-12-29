// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResultModel _$AuthResultModelFromJson(Map<String, dynamic> json) =>
    AuthResultModel(
      userModel: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$AuthResultModelToJson(AuthResultModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.userModel.toJson(),
    };
