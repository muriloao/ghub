import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/gaming_platform.dart';

part 'gaming_platform_model.g.dart';

@JsonSerializable()
class GamingPlatformModel extends GamingPlatform {
  @JsonKey(name: 'platform_type')
  final String platformTypeName;

  GamingPlatformModel({
    required this.platformTypeName,
    required bool isConnected,
    String? username,
    DateTime? connectedAt,
  }) : super(
         type: _platformTypeFromString(platformTypeName),
         isConnected: isConnected,
         username: username,
         connectedAt: connectedAt,
       );

  factory GamingPlatformModel.fromJson(Map<String, dynamic> json) =>
      _$GamingPlatformModelFromJson(json);

  Map<String, dynamic> toJson() => _$GamingPlatformModelToJson(this);

  factory GamingPlatformModel.fromDomain(GamingPlatform platform) {
    return GamingPlatformModel(
      platformTypeName: platform.type.name.toLowerCase(),
      isConnected: platform.isConnected,
      username: platform.username,
      connectedAt: platform.connectedAt,
    );
  }

  Map<String, dynamic> toServerJson() {
    return {
      'platform_type': type.name.toLowerCase(),
      'is_connected': isConnected,
      'username': username,
      'connected_at': connectedAt?.toIso8601String(),
    };
  }

  static PlatformType _platformTypeFromString(String platformTypeName) {
    for (PlatformType type in PlatformType.values) {
      if (type.name.toLowerCase() == platformTypeName.toLowerCase()) {
        return type;
      }
    }
    return PlatformType.steam; // Default fallback
  }
}
