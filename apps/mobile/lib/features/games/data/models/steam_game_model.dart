import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/game.dart';

part 'steam_game_model.g.dart';

@JsonSerializable()
class SteamGameModel {
  @JsonKey(name: 'appid')
  final int appId;

  final String name;

  @JsonKey(name: 'playtime_forever')
  final int playtimeForeverRaw;

  @JsonKey(name: 'playtime_windows_forever')
  final int? playtimeWindowsForever;

  @JsonKey(name: 'playtime_mac_forever')
  final int? playtimeMacForever;

  @JsonKey(name: 'playtime_linux_forever')
  final int? playtimeLinuxForever;

  @JsonKey(name: 'playtime_deck_forever')
  final int? playtimeDeckForever;

  @JsonKey(name: 'rtime_last_played')
  final int? rtimeLastPlayed;

  @JsonKey(name: 'playtime_disconnected')
  final int? playtimeDisconnected;

  @JsonKey(name: 'img_icon_url')
  final String? imgIconUrl;

  @JsonKey(name: 'img_logo_url')
  final String? imgLogoUrl;

  @JsonKey(name: 'has_community_visible_stats')
  final bool? hasCommunityVisibleStats;

  @JsonKey(name: 'playtime_2weeks')
  final int? playtime2WeeksRaw;

  const SteamGameModel({
    required this.appId,
    required this.name,
    required this.playtimeForeverRaw,
    this.playtimeWindowsForever,
    this.playtimeMacForever,
    this.playtimeLinuxForever,
    this.playtimeDeckForever,
    this.rtimeLastPlayed,
    this.playtimeDisconnected,
    this.imgIconUrl,
    this.imgLogoUrl,
    this.hasCommunityVisibleStats,
    this.playtime2WeeksRaw,
  });

  factory SteamGameModel.fromJson(Map<String, dynamic> json) =>
      _$SteamGameModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamGameModelToJson(this);

  Game toDomainEntity() {
    return Game(
      id: appId.toString(),
      name: name,
      imageUrl: imgIconUrl != null
          ? 'https://media.steampowered.com/steamcommunity/public/images/apps/$appId/$imgIconUrl.jpg'
          : null,
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/$appId/header.jpg',
      status: GameStatus.owned,
      platforms: [GamePlatform.pc],
      playtimeForever: playtimeForeverRaw,
      playtime2Weeks: playtime2WeeksRaw,
      lastPlayed: rtimeLastPlayed != null
          ? DateTime.fromMillisecondsSinceEpoch(rtimeLastPlayed! * 1000)
          : null,
    );
  }
}

@JsonSerializable()
class SteamOwnedGamesResponse {
  @JsonKey(name: 'game_count')
  final int gameCount;

  final List<SteamGameModel> games;

  const SteamOwnedGamesResponse({required this.gameCount, required this.games});

  factory SteamOwnedGamesResponse.fromJson(Map<String, dynamic> json) =>
      _$SteamOwnedGamesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SteamOwnedGamesResponseToJson(this);
}
