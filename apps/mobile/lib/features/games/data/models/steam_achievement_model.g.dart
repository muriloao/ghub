// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steam_achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SteamAchievementModel _$SteamAchievementModelFromJson(
  Map<String, dynamic> json,
) => SteamAchievementModel(
  apiName: json['apiname'] as String,
  achieved: (json['achieved'] as num).toInt(),
  unlockTime: (json['unlocktime'] as num).toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$SteamAchievementModelToJson(
  SteamAchievementModel instance,
) => <String, dynamic>{
  'apiname': instance.apiName,
  'achieved': instance.achieved,
  'unlocktime': instance.unlockTime,
  'name': instance.name,
  'description': instance.description,
};

SteamAchievementSchemaModel _$SteamAchievementSchemaModelFromJson(
  Map<String, dynamic> json,
) => SteamAchievementSchemaModel(
  name: json['name'] as String,
  displayName: json['displayName'] as String,
  description: json['description'] as String?,
  iconUrl: json['icon'] as String,
  iconGrayUrl: json['icongray'] as String,
  hidden: (json['hidden'] as num?)?.toInt(),
  defaultValue: (json['defaultvalue'] as num?)?.toInt(),
);

Map<String, dynamic> _$SteamAchievementSchemaModelToJson(
  SteamAchievementSchemaModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'displayName': instance.displayName,
  'description': instance.description,
  'icon': instance.iconUrl,
  'icongray': instance.iconGrayUrl,
  'hidden': instance.hidden,
  'defaultvalue': instance.defaultValue,
};

SteamPlayerAchievementsResponse _$SteamPlayerAchievementsResponseFromJson(
  Map<String, dynamic> json,
) => SteamPlayerAchievementsResponse(
  steamId: json['steamID'] as String,
  gameName: json['gameName'] as String,
  achievements: (json['achievements'] as List<dynamic>)
      .map((e) => SteamAchievementModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  success: json['success'] as bool,
);

Map<String, dynamic> _$SteamPlayerAchievementsResponseToJson(
  SteamPlayerAchievementsResponse instance,
) => <String, dynamic>{
  'steamID': instance.steamId,
  'gameName': instance.gameName,
  'achievements': instance.achievements.map((e) => e.toJson()).toList(),
  'success': instance.success,
};

SteamAchievementSchemaResponse _$SteamAchievementSchemaResponseFromJson(
  Map<String, dynamic> json,
) => SteamAchievementSchemaResponse(
  gameName: json['gameName'] as String,
  gameVersion: json['gameVersion'] as String,
  availableGameStats: json['availableGameStats'] as Map<String, dynamic>,
);

Map<String, dynamic> _$SteamAchievementSchemaResponseToJson(
  SteamAchievementSchemaResponse instance,
) => <String, dynamic>{
  'gameName': instance.gameName,
  'gameVersion': instance.gameVersion,
  'availableGameStats': instance.availableGameStats,
};

SteamGlobalAchievementPercentagesResponse
_$SteamGlobalAchievementPercentagesResponseFromJson(
  Map<String, dynamic> json,
) => SteamGlobalAchievementPercentagesResponse(
  achievements: (json['achievements'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$SteamGlobalAchievementPercentagesResponseToJson(
  SteamGlobalAchievementPercentagesResponse instance,
) => <String, dynamic>{'achievements': instance.achievements};
