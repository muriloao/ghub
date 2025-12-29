import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/signup_request.dart';

part 'signup_request_model.g.dart';

@JsonSerializable()
class SignUpRequestModel extends SignUpRequest {
  const SignUpRequestModel({
    required super.gamertag,
    required super.email,
    required super.password,
    required super.confirmPassword,
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestModelToJson(this);

  // Para envio ao servidor (sem confirmPassword)
  Map<String, dynamic> toServerJson() => {
    'gamertag': gamertag,
    'email': email,
    'password': password,
  };
}
