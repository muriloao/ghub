import 'package:json_annotation/json_annotation.dart';

part 'steam_game_details_model.g.dart';

@JsonSerializable()
class SteamGameDetailsResponse {
  final Map<String, SteamGameDetailsModel?> data;

  const SteamGameDetailsResponse({required this.data});

  factory SteamGameDetailsResponse.fromJson(Map<String, dynamic> json) {
    final data = <String, SteamGameDetailsModel?>{};
    json.forEach((key, value) {
      if (value != null && value['success'] == true && value['data'] != null) {
        data[key] = SteamGameDetailsModel.fromJson(value['data']);
      } else {
        data[key] = null;
      }
    });
    return SteamGameDetailsResponse(data: data);
  }

  Map<String, dynamic> toJson() => _$SteamGameDetailsResponseToJson(this);
}

@JsonSerializable()
class SteamGameDetailsModel {
  final String type;
  final String name;
  @JsonKey(name: 'steam_appid')
  final int steamAppId;
  @JsonKey(name: 'required_age')
  final dynamic requiredAge;
  @JsonKey(name: 'is_free')
  final bool isFree;
  @JsonKey(name: 'detailed_description')
  final String? detailedDescription;
  @JsonKey(name: 'about_the_game')
  final String? aboutTheGame;
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  @JsonKey(name: 'header_image')
  final String? headerImage;
  final String? website;
  @JsonKey(name: 'pc_requirements')
  final dynamic pcRequirements;
  @JsonKey(name: 'mac_requirements')
  final dynamic macRequirements;
  @JsonKey(name: 'linux_requirements')
  final dynamic linuxRequirements;
  final List<String>? developers;
  final List<String>? publishers;
  @JsonKey(name: 'package_groups')
  final List<dynamic>? packageGroups;
  final SteamPlatformsModel? platforms;
  final List<SteamCategoryModel>? categories;
  final List<SteamGenreModel>? genres;
  final List<SteamScreenshotModel>? screenshots;
  final List<SteamMovieModel>? movies;
  @JsonKey(name: 'release_date')
  final SteamReleaseDateModel? releaseDate;
  @JsonKey(name: 'support_info')
  final SteamSupportInfoModel? supportInfo;
  final String? background;
  @JsonKey(name: 'content_descriptors')
  final SteamContentDescriptorsModel? contentDescriptors;

  const SteamGameDetailsModel({
    required this.type,
    required this.name,
    required this.steamAppId,
    this.requiredAge,
    required this.isFree,
    this.detailedDescription,
    this.aboutTheGame,
    this.shortDescription,
    this.headerImage,
    this.website,
    this.pcRequirements,
    this.macRequirements,
    this.linuxRequirements,
    this.developers,
    this.publishers,
    this.packageGroups,
    this.platforms,
    this.categories,
    this.genres,
    this.screenshots,
    this.movies,
    this.releaseDate,
    this.supportInfo,
    this.background,
    this.contentDescriptors,
  });

  factory SteamGameDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$SteamGameDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamGameDetailsModelToJson(this);
}

@JsonSerializable()
class SteamPlatformsModel {
  final bool windows;
  final bool mac;
  final bool linux;

  const SteamPlatformsModel({
    required this.windows,
    required this.mac,
    required this.linux,
  });

  factory SteamPlatformsModel.fromJson(Map<String, dynamic> json) =>
      _$SteamPlatformsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamPlatformsModelToJson(this);
}

@JsonSerializable()
class SteamCategoryModel {
  final int id;
  final String description;

  const SteamCategoryModel({required this.id, required this.description});

  factory SteamCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SteamCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamCategoryModelToJson(this);
}

@JsonSerializable()
class SteamGenreModel {
  final String id;
  final String description;

  const SteamGenreModel({required this.id, required this.description});

  factory SteamGenreModel.fromJson(Map<String, dynamic> json) =>
      _$SteamGenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamGenreModelToJson(this);
}

@JsonSerializable()
class SteamScreenshotModel {
  final int id;
  @JsonKey(name: 'path_thumbnail')
  final String pathThumbnail;
  @JsonKey(name: 'path_full')
  final String pathFull;

  const SteamScreenshotModel({
    required this.id,
    required this.pathThumbnail,
    required this.pathFull,
  });

  factory SteamScreenshotModel.fromJson(Map<String, dynamic> json) =>
      _$SteamScreenshotModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamScreenshotModelToJson(this);
}

@JsonSerializable()
class SteamMovieModel {
  final int id;
  final String name;
  final String thumbnail;
  final SteamWebmModel? webm;
  final SteamMp4Model? mp4;
  final bool highlight;

  const SteamMovieModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.webm,
    this.mp4,
    required this.highlight,
  });

  factory SteamMovieModel.fromJson(Map<String, dynamic> json) =>
      _$SteamMovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamMovieModelToJson(this);
}

@JsonSerializable()
class SteamWebmModel {
  @JsonKey(name: '480')
  final String? quality480;
  @JsonKey(name: 'max')
  final String? qualityMax;

  const SteamWebmModel({this.quality480, this.qualityMax});

  factory SteamWebmModel.fromJson(Map<String, dynamic> json) =>
      _$SteamWebmModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamWebmModelToJson(this);
}

@JsonSerializable()
class SteamMp4Model {
  @JsonKey(name: '480')
  final String? quality480;
  @JsonKey(name: 'max')
  final String? qualityMax;

  const SteamMp4Model({this.quality480, this.qualityMax});

  factory SteamMp4Model.fromJson(Map<String, dynamic> json) =>
      _$SteamMp4ModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamMp4ModelToJson(this);
}

@JsonSerializable()
class SteamReleaseDateModel {
  @JsonKey(name: 'coming_soon')
  final bool comingSoon;
  final String date;

  const SteamReleaseDateModel({required this.comingSoon, required this.date});

  factory SteamReleaseDateModel.fromJson(Map<String, dynamic> json) =>
      _$SteamReleaseDateModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamReleaseDateModelToJson(this);
}

@JsonSerializable()
class SteamSupportInfoModel {
  final String? url;
  final String? email;

  const SteamSupportInfoModel({this.url, this.email});

  factory SteamSupportInfoModel.fromJson(Map<String, dynamic> json) =>
      _$SteamSupportInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamSupportInfoModelToJson(this);
}

@JsonSerializable()
class SteamContentDescriptorsModel {
  final List<int>? ids;
  final String? notes;

  const SteamContentDescriptorsModel({this.ids, this.notes});

  factory SteamContentDescriptorsModel.fromJson(Map<String, dynamic> json) =>
      _$SteamContentDescriptorsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamContentDescriptorsModelToJson(this);
}
