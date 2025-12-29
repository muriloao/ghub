import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/platform_connection_request.dart';

part 'platform_connection_request_model.g.dart';

@JsonSerializable()
class PlatformConnectionRequestModel extends PlatformConnectionRequest {
  const PlatformConnectionRequestModel({
    required String platformId,
    required Map<String, dynamic> credentials,
  }) : super(platformId: platformId, credentials: credentials);

  factory PlatformConnectionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PlatformConnectionRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformConnectionRequestModelToJson(this);

  factory PlatformConnectionRequestModel.fromDomain(
    PlatformConnectionRequest request,
  ) {
    return PlatformConnectionRequestModel(
      platformId: request.platformId,
      credentials: request.credentials,
    );
  }

  Map<String, dynamic> toServerJson() {
    return {'platform_id': platformId, 'credentials': credentials};
  }
}
