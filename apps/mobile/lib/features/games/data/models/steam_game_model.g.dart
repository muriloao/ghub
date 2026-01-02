// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steam_game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SteamGameModel _$SteamGameModelFromJson(Map<String, dynamic> json) =>
    SteamGameModel(
      appId: (json['appid'] as num).toInt(),
      name: json['name'] as String,
      playtimeForeverRaw: (json['playtime_forever'] as num).toInt(),
      playtimeWindowsForever: (json['playtime_windows_forever'] as num?)
          ?.toInt(),
      playtimeMacForever: (json['playtime_mac_forever'] as num?)?.toInt(),
      playtimeLinuxForever: (json['playtime_linux_forever'] as num?)?.toInt(),
      playtimeDeckForever: (json['playtime_deck_forever'] as num?)?.toInt(),
      rtimeLastPlayed: (json['rtime_last_played'] as num?)?.toInt(),
      playtimeDisconnected: (json['playtime_disconnected'] as num?)?.toInt(),
      imgIconUrl: json['img_icon_url'] as String?,
      imgLogoUrl: json['img_logo_url'] as String?,
      hasCommunityVisibleStats: json['has_community_visible_stats'] as bool?,
      playtime2WeeksRaw: (json['playtime_2weeks'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SteamGameModelToJson(SteamGameModel instance) =>
    <String, dynamic>{
      'appid': instance.appId,
      'name': instance.name,
      'playtime_forever': instance.playtimeForeverRaw,
      'playtime_windows_forever': instance.playtimeWindowsForever,
      'playtime_mac_forever': instance.playtimeMacForever,
      'playtime_linux_forever': instance.playtimeLinuxForever,
      'playtime_deck_forever': instance.playtimeDeckForever,
      'rtime_last_played': instance.rtimeLastPlayed,
      'playtime_disconnected': instance.playtimeDisconnected,
      'img_icon_url': instance.imgIconUrl,
      'img_logo_url': instance.imgLogoUrl,
      'has_community_visible_stats': instance.hasCommunityVisibleStats,
      'playtime_2weeks': instance.playtime2WeeksRaw,
    };

SteamOwnedGamesResponse _$SteamOwnedGamesResponseFromJson(
  Map<String, dynamic> json,
) => SteamOwnedGamesResponse(
  gameCount: (json['game_count'] as num).toInt(),
  games: (json['games'] as List<dynamic>)
      .map((e) => SteamGameModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SteamOwnedGamesResponseToJson(
  SteamOwnedGamesResponse instance,
) => <String, dynamic>{
  'game_count': instance.gameCount,
  'games': instance.games.map((e) => e.toJson()).toList(),
};
