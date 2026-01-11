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
  baseUrl: json['base_url'] as String,
  auth: json['auth'] as String,
  userProfile: json['user_profile'] as String,
  gameLibrary: json['game_library'] as String,
  achievements: json['achievements'] as String,
  friendsList: json['friends_list'] as String?,
  gameStats: json['game_stats'] as String?,
);

Map<String, dynamic> _$$PlatformEndpointsImplToJson(
  _$PlatformEndpointsImpl instance,
) => <String, dynamic>{
  'base_url': instance.baseUrl,
  'auth': instance.auth,
  'user_profile': instance.userProfile,
  'game_library': instance.gameLibrary,
  'achievements': instance.achievements,
  'friends_list': instance.friendsList,
  'game_stats': instance.gameStats,
};

_$PlatformAuthConfigImpl _$$PlatformAuthConfigImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformAuthConfigImpl(
  type: json['type'] as String,
  clientIdRequired: json['client_id_required'] as bool,
  secretRequired: json['secret_required'] as bool,
  redirectUri: json['redirect_uri'] as String,
  scopes: (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$PlatformAuthConfigImplToJson(
  _$PlatformAuthConfigImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'client_id_required': instance.clientIdRequired,
  'secret_required': instance.secretRequired,
  'redirect_uri': instance.redirectUri,
  'scopes': instance.scopes,
};

_$PlatformFeaturesImpl _$$PlatformFeaturesImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformFeaturesImpl(
  gameLibrary: json['game_library'] as bool,
  achievements: json['achievements'] as bool,
  friendsList: json['friends_list'] as bool,
  gameStats: json['game_stats'] as bool,
  screenshots: json['screenshots'] as bool,
  gameTime: json['game_time'] as bool,
);

Map<String, dynamic> _$$PlatformFeaturesImplToJson(
  _$PlatformFeaturesImpl instance,
) => <String, dynamic>{
  'game_library': instance.gameLibrary,
  'achievements': instance.achievements,
  'friends_list': instance.friendsList,
  'game_stats': instance.gameStats,
  'screenshots': instance.screenshots,
  'game_time': instance.gameTime,
};

_$PlatformApiModelImpl _$$PlatformApiModelImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformApiModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  displayName: json['display_name'] as String,
  description: json['description'] as String,
  logoUrl: json['logo_url'] as String,
  colorScheme: PlatformColorScheme.fromJson(
    json['color_scheme'] as Map<String, dynamic>,
  ),
  endpoints: PlatformEndpoints.fromJson(
    json['endpoints'] as Map<String, dynamic>,
  ),
  authConfig: PlatformAuthConfig.fromJson(
    json['auth_config'] as Map<String, dynamic>,
  ),
  features: PlatformFeatures.fromJson(json['features'] as Map<String, dynamic>),
  isEnabled: json['is_enabled'] as bool,
  comingSoon: json['coming_soon'] as bool,
  priority: (json['priority'] as num).toInt(),
);

Map<String, dynamic> _$$PlatformApiModelImplToJson(
  _$PlatformApiModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'display_name': instance.displayName,
  'description': instance.description,
  'logo_url': instance.logoUrl,
  'color_scheme': instance.colorScheme.toJson(),
  'endpoints': instance.endpoints.toJson(),
  'auth_config': instance.authConfig.toJson(),
  'features': instance.features.toJson(),
  'is_enabled': instance.isEnabled,
  'coming_soon': instance.comingSoon,
  'priority': instance.priority,
};

_$PlatformsListResponseImpl _$$PlatformsListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformsListResponseImpl(
  platforms: (json['platforms'] as List<dynamic>)
      .map((e) => PlatformApiModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['total_count'] as num).toInt(),
  lastUpdated: json['last_updated'] as String,
);

Map<String, dynamic> _$$PlatformsListResponseImplToJson(
  _$PlatformsListResponseImpl instance,
) => <String, dynamic>{
  'platforms': instance.platforms.map((e) => e.toJson()).toList(),
  'total_count': instance.totalCount,
  'last_updated': instance.lastUpdated,
};
