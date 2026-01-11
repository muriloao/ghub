// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlatformColorSchemeImpl _$$PlatformColorSchemeImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformColorSchemeImpl(
  primary: json['primary'] as String,
  secondary: json['secondary'] as String,
);

Map<String, dynamic> _$$PlatformColorSchemeImplToJson(
  _$PlatformColorSchemeImpl instance,
) => <String, dynamic>{
  'primary': instance.primary,
  'secondary': instance.secondary,
};

_$PlatformEndpointsImpl _$$PlatformEndpointsImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformEndpointsImpl(
  baseUrl: json['baseUrl'] as String,
  auth: json['auth'] as String,
  userProfile: json['userProfile'] as String,
  gameLibrary: json['gameLibrary'] as String,
  achievements: json['achievements'] as String,
  friendsList: json['friendsList'] as String?,
  gameStats: json['gameStats'] as String?,
);

Map<String, dynamic> _$$PlatformEndpointsImplToJson(
  _$PlatformEndpointsImpl instance,
) => <String, dynamic>{
  'baseUrl': instance.baseUrl,
  'auth': instance.auth,
  'userProfile': instance.userProfile,
  'gameLibrary': instance.gameLibrary,
  'achievements': instance.achievements,
  'friendsList': instance.friendsList,
  'gameStats': instance.gameStats,
};

_$PlatformAuthConfigImpl _$$PlatformAuthConfigImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformAuthConfigImpl(
  type: json['type'] as String,
  clientIdRequired: json['clientIdRequired'] as bool,
  secretRequired: json['secretRequired'] as bool,
  redirectUri: json['redirectUri'] as String,
  scopes: (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$PlatformAuthConfigImplToJson(
  _$PlatformAuthConfigImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'clientIdRequired': instance.clientIdRequired,
  'secretRequired': instance.secretRequired,
  'redirectUri': instance.redirectUri,
  'scopes': instance.scopes,
};

_$PlatformFeaturesImpl _$$PlatformFeaturesImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformFeaturesImpl(
  gameLibrary: json['gameLibrary'] as bool,
  achievements: json['achievements'] as bool,
  friendsList: json['friendsList'] as bool,
  gameStats: json['gameStats'] as bool,
  screenshots: json['screenshots'] as bool,
  gameTime: json['gameTime'] as bool,
);

Map<String, dynamic> _$$PlatformFeaturesImplToJson(
  _$PlatformFeaturesImpl instance,
) => <String, dynamic>{
  'gameLibrary': instance.gameLibrary,
  'achievements': instance.achievements,
  'friendsList': instance.friendsList,
  'gameStats': instance.gameStats,
  'screenshots': instance.screenshots,
  'gameTime': instance.gameTime,
};

_$PlatformApiModelImpl _$$PlatformApiModelImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformApiModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  displayName: json['displayName'] as String,
  description: json['description'] as String,
  logoUrl: json['logoUrl'] as String,
  colorScheme: PlatformColorScheme.fromJson(
    json['colorScheme'] as Map<String, dynamic>,
  ),
  endpoints: PlatformEndpoints.fromJson(
    json['endpoints'] as Map<String, dynamic>,
  ),
  authConfig: PlatformAuthConfig.fromJson(
    json['authConfig'] as Map<String, dynamic>,
  ),
  features: PlatformFeatures.fromJson(json['features'] as Map<String, dynamic>),
  isEnabled: json['isEnabled'] as bool,
  comingSoon: json['comingSoon'] as bool,
  priority: (json['priority'] as num).toInt(),
);

Map<String, dynamic> _$$PlatformApiModelImplToJson(
  _$PlatformApiModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'displayName': instance.displayName,
  'description': instance.description,
  'logoUrl': instance.logoUrl,
  'colorScheme': instance.colorScheme.toJson(),
  'endpoints': instance.endpoints.toJson(),
  'authConfig': instance.authConfig.toJson(),
  'features': instance.features.toJson(),
  'isEnabled': instance.isEnabled,
  'comingSoon': instance.comingSoon,
  'priority': instance.priority,
};

_$PlatformsListResponseImpl _$$PlatformsListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformsListResponseImpl(
  platforms: (json['platforms'] as List<dynamic>)
      .map((e) => PlatformApiModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  lastUpdated: json['lastUpdated'] as String,
);

Map<String, dynamic> _$$PlatformsListResponseImplToJson(
  _$PlatformsListResponseImpl instance,
) => <String, dynamic>{
  'platforms': instance.platforms.map((e) => e.toJson()).toList(),
  'totalCount': instance.totalCount,
  'lastUpdated': instance.lastUpdated,
};
