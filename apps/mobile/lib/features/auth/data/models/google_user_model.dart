import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'google_user_model.g.dart';

@JsonSerializable()
class GoogleUserModel extends User {
  const GoogleUserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
  });

  /// Cria User a partir de JSON
  factory GoogleUserModel.fromJson(Map<String, dynamic> json) {
    return GoogleUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['displayName'] as String?,
      avatarUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$GoogleUserModelToJson(this);

  factory GoogleUserModel.fromEntity(User user) {
    return GoogleUserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
