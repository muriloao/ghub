// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequestModel _$SignUpRequestModelFromJson(Map<String, dynamic> json) =>
    SignUpRequestModel(
      gamertag: json['gamertag'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirm_password'] as String,
    );

Map<String, dynamic> _$SignUpRequestModelToJson(SignUpRequestModel instance) =>
    <String, dynamic>{
      'gamertag': instance.gamertag,
      'email': instance.email,
      'password': instance.password,
      'confirm_password': instance.confirmPassword,
    };
