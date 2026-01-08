import 'package:ghub_mobile/features/auth/data/models/google_user_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_result.dart';

part 'auth_result_model.g.dart';

@JsonSerializable()
class AuthResultModel extends AuthResult {
  @JsonKey(name: 'user')
  final GoogleUserModel userModel;

  const AuthResultModel({
    required this.userModel,
    required super.accessToken,
    required super.refreshToken,
  }) : super(user: userModel);

  factory AuthResultModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResultModelToJson(this);
}
