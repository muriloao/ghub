// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steam_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SteamUserModel _$SteamUserModelFromJson(Map<String, dynamic> json) =>
    SteamUserModel(
      steamid: json['steamid'] as String,
      communityvisibilitystate: (json['communityvisibilitystate'] as num)
          .toInt(),
      profilestate: (json['profilestate'] as num).toInt(),
      personaname: json['personaname'] as String,
      lastlogoff: (json['lastlogoff'] as num).toInt(),
      commentpermission: (json['commentpermission'] as num).toInt(),
      profileurl: json['profileurl'] as String,
      avatar: json['avatar'] as String,
      avatarmedium: json['avatarmedium'] as String,
      avatarfull: json['avatarfull'] as String,
      avatarhash: json['avatarhash'] as String,
      personastate: (json['personastate'] as num).toInt(),
      realname: json['realname'] as String?,
      primaryclanid: json['primaryclanid'] as String?,
      timecreated: (json['timecreated'] as num?)?.toInt(),
      personastateflags: (json['personastateflags'] as num?)?.toInt(),
      loccountrycode: json['loccountrycode'] as String?,
      locstatecode: json['locstatecode'] as String?,
      loccityid: (json['loccityid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SteamUserModelToJson(SteamUserModel instance) =>
    <String, dynamic>{
      'steamid': instance.steamid,
      'communityvisibilitystate': instance.communityvisibilitystate,
      'profilestate': instance.profilestate,
      'personaname': instance.personaname,
      'lastlogoff': instance.lastlogoff,
      'commentpermission': instance.commentpermission,
      'profileurl': instance.profileurl,
      'avatar': instance.avatar,
      'avatarmedium': instance.avatarmedium,
      'avatarfull': instance.avatarfull,
      'avatarhash': instance.avatarhash,
      'personastate': instance.personastate,
      'realname': instance.realname,
      'primaryclanid': instance.primaryclanid,
      'timecreated': instance.timecreated,
      'personastateflags': instance.personastateflags,
      'loccountrycode': instance.loccountrycode,
      'locstatecode': instance.locstatecode,
      'loccityid': instance.loccityid,
    };

SteamPlayersResponse _$SteamPlayersResponseFromJson(
  Map<String, dynamic> json,
) => SteamPlayersResponse(
  response: SteamPlayersData.fromJson(json['response'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SteamPlayersResponseToJson(
  SteamPlayersResponse instance,
) => <String, dynamic>{'response': instance.response.toJson()};

SteamPlayersData _$SteamPlayersDataFromJson(Map<String, dynamic> json) =>
    SteamPlayersData(
      players: (json['players'] as List<dynamic>)
          .map((e) => SteamUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SteamPlayersDataToJson(SteamPlayersData instance) =>
    <String, dynamic>{
      'players': instance.players.map((e) => e.toJson()).toList(),
    };
