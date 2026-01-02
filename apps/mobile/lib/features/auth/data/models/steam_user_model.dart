import 'package:json_annotation/json_annotation.dart';

part 'steam_user_model.g.dart';

@JsonSerializable()
class SteamUserModel {
  final String steamid;
  final int communityvisibilitystate;
  final int profilestate;
  final String personaname;
  final int lastlogoff;
  final int commentpermission;
  final String profileurl;
  final String avatar;
  final String avatarmedium;
  final String avatarfull;
  final String avatarhash;
  final int personastate;
  final String? realname;
  final String? primaryclanid;
  final int? timecreated;
  final int? personastateflags;
  final String? loccountrycode;
  final String? locstatecode;
  final int? loccityid;

  SteamUserModel({
    required this.steamid,
    required this.communityvisibilitystate,
    required this.profilestate,
    required this.personaname,
    required this.lastlogoff,
    required this.commentpermission,
    required this.profileurl,
    required this.avatar,
    required this.avatarmedium,
    required this.avatarfull,
    required this.avatarhash,
    required this.personastate,
    this.realname,
    this.primaryclanid,
    this.timecreated,
    this.personastateflags,
    this.loccountrycode,
    this.locstatecode,
    this.loccityid,
  });

  factory SteamUserModel.fromJson(Map<String, dynamic> json) =>
      _$SteamUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamUserModelToJson(this);
}

@JsonSerializable()
class SteamPlayersResponse {
  final SteamPlayersData response;

  SteamPlayersResponse({required this.response});

  factory SteamPlayersResponse.fromJson(Map<String, dynamic> json) =>
      _$SteamPlayersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SteamPlayersResponseToJson(this);
}

@JsonSerializable()
class SteamPlayersData {
  final List<SteamUserModel> players;

  SteamPlayersData({required this.players});

  factory SteamPlayersData.fromJson(Map<String, dynamic> json) =>
      _$SteamPlayersDataFromJson(json);

  Map<String, dynamic> toJson() => _$SteamPlayersDataToJson(this);
}
