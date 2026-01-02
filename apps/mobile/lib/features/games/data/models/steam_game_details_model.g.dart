// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steam_game_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SteamGameDetailsResponse _$SteamGameDetailsResponseFromJson(
  Map<String, dynamic> json,
) => SteamGameDetailsResponse(
  data: (json['data'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      e == null
          ? null
          : SteamGameDetailsModel.fromJson(e as Map<String, dynamic>),
    ),
  ),
);

Map<String, dynamic> _$SteamGameDetailsResponseToJson(
  SteamGameDetailsResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((k, e) => MapEntry(k, e?.toJson())),
};

SteamGameDetailsModel _$SteamGameDetailsModelFromJson(
  Map<String, dynamic> json,
) => SteamGameDetailsModel(
  type: json['type'] as String,
  name: json['name'] as String,
  steamAppId: (json['steam_appid'] as num).toInt(),
  requiredAge: json['required_age'],
  isFree: json['is_free'] as bool,
  detailedDescription: json['detailed_description'] as String?,
  aboutTheGame: json['about_the_game'] as String?,
  shortDescription: json['short_description'] as String?,
  headerImage: json['header_image'] as String?,
  website: json['website'] as String?,
  pcRequirements: json['pc_requirements'],
  macRequirements: json['mac_requirements'],
  linuxRequirements: json['linux_requirements'],
  developers: (json['developers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  publishers: (json['publishers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  packageGroups: json['package_groups'] as List<dynamic>?,
  platforms: json['platforms'] == null
      ? null
      : SteamPlatformsModel.fromJson(json['platforms'] as Map<String, dynamic>),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => SteamCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  genres: (json['genres'] as List<dynamic>?)
      ?.map((e) => SteamGenreModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  screenshots: (json['screenshots'] as List<dynamic>?)
      ?.map((e) => SteamScreenshotModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  movies: (json['movies'] as List<dynamic>?)
      ?.map((e) => SteamMovieModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  releaseDate: json['release_date'] == null
      ? null
      : SteamReleaseDateModel.fromJson(
          json['release_date'] as Map<String, dynamic>,
        ),
  supportInfo: json['support_info'] == null
      ? null
      : SteamSupportInfoModel.fromJson(
          json['support_info'] as Map<String, dynamic>,
        ),
  background: json['background'] as String?,
  contentDescriptors: json['content_descriptors'] == null
      ? null
      : SteamContentDescriptorsModel.fromJson(
          json['content_descriptors'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SteamGameDetailsModelToJson(
  SteamGameDetailsModel instance,
) => <String, dynamic>{
  'type': instance.type,
  'name': instance.name,
  'steam_appid': instance.steamAppId,
  'required_age': instance.requiredAge,
  'is_free': instance.isFree,
  'detailed_description': instance.detailedDescription,
  'about_the_game': instance.aboutTheGame,
  'short_description': instance.shortDescription,
  'header_image': instance.headerImage,
  'website': instance.website,
  'pc_requirements': instance.pcRequirements,
  'mac_requirements': instance.macRequirements,
  'linux_requirements': instance.linuxRequirements,
  'developers': instance.developers,
  'publishers': instance.publishers,
  'package_groups': instance.packageGroups,
  'platforms': instance.platforms?.toJson(),
  'categories': instance.categories?.map((e) => e.toJson()).toList(),
  'genres': instance.genres?.map((e) => e.toJson()).toList(),
  'screenshots': instance.screenshots?.map((e) => e.toJson()).toList(),
  'movies': instance.movies?.map((e) => e.toJson()).toList(),
  'release_date': instance.releaseDate?.toJson(),
  'support_info': instance.supportInfo?.toJson(),
  'background': instance.background,
  'content_descriptors': instance.contentDescriptors?.toJson(),
};

SteamPlatformsModel _$SteamPlatformsModelFromJson(Map<String, dynamic> json) =>
    SteamPlatformsModel(
      windows: json['windows'] as bool,
      mac: json['mac'] as bool,
      linux: json['linux'] as bool,
    );

Map<String, dynamic> _$SteamPlatformsModelToJson(
  SteamPlatformsModel instance,
) => <String, dynamic>{
  'windows': instance.windows,
  'mac': instance.mac,
  'linux': instance.linux,
};

SteamCategoryModel _$SteamCategoryModelFromJson(Map<String, dynamic> json) =>
    SteamCategoryModel(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$SteamCategoryModelToJson(SteamCategoryModel instance) =>
    <String, dynamic>{'id': instance.id, 'description': instance.description};

SteamGenreModel _$SteamGenreModelFromJson(Map<String, dynamic> json) =>
    SteamGenreModel(
      id: json['id'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$SteamGenreModelToJson(SteamGenreModel instance) =>
    <String, dynamic>{'id': instance.id, 'description': instance.description};

SteamScreenshotModel _$SteamScreenshotModelFromJson(
  Map<String, dynamic> json,
) => SteamScreenshotModel(
  id: (json['id'] as num).toInt(),
  pathThumbnail: json['path_thumbnail'] as String,
  pathFull: json['path_full'] as String,
);

Map<String, dynamic> _$SteamScreenshotModelToJson(
  SteamScreenshotModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'path_thumbnail': instance.pathThumbnail,
  'path_full': instance.pathFull,
};

SteamMovieModel _$SteamMovieModelFromJson(Map<String, dynamic> json) =>
    SteamMovieModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      thumbnail: json['thumbnail'] as String,
      webm: json['webm'] == null
          ? null
          : SteamWebmModel.fromJson(json['webm'] as Map<String, dynamic>),
      mp4: json['mp4'] == null
          ? null
          : SteamMp4Model.fromJson(json['mp4'] as Map<String, dynamic>),
      highlight: json['highlight'] as bool,
    );

Map<String, dynamic> _$SteamMovieModelToJson(SteamMovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
      'webm': instance.webm?.toJson(),
      'mp4': instance.mp4?.toJson(),
      'highlight': instance.highlight,
    };

SteamWebmModel _$SteamWebmModelFromJson(Map<String, dynamic> json) =>
    SteamWebmModel(
      quality480: json['480'] as String?,
      qualityMax: json['max'] as String?,
    );

Map<String, dynamic> _$SteamWebmModelToJson(SteamWebmModel instance) =>
    <String, dynamic>{'480': instance.quality480, 'max': instance.qualityMax};

SteamMp4Model _$SteamMp4ModelFromJson(Map<String, dynamic> json) =>
    SteamMp4Model(
      quality480: json['480'] as String?,
      qualityMax: json['max'] as String?,
    );

Map<String, dynamic> _$SteamMp4ModelToJson(SteamMp4Model instance) =>
    <String, dynamic>{'480': instance.quality480, 'max': instance.qualityMax};

SteamReleaseDateModel _$SteamReleaseDateModelFromJson(
  Map<String, dynamic> json,
) => SteamReleaseDateModel(
  comingSoon: json['coming_soon'] as bool,
  date: json['date'] as String,
);

Map<String, dynamic> _$SteamReleaseDateModelToJson(
  SteamReleaseDateModel instance,
) => <String, dynamic>{
  'coming_soon': instance.comingSoon,
  'date': instance.date,
};

SteamSupportInfoModel _$SteamSupportInfoModelFromJson(
  Map<String, dynamic> json,
) => SteamSupportInfoModel(
  url: json['url'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$SteamSupportInfoModelToJson(
  SteamSupportInfoModel instance,
) => <String, dynamic>{'url': instance.url, 'email': instance.email};

SteamContentDescriptorsModel _$SteamContentDescriptorsModelFromJson(
  Map<String, dynamic> json,
) => SteamContentDescriptorsModel(
  ids: (json['ids'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$SteamContentDescriptorsModelToJson(
  SteamContentDescriptorsModel instance,
) => <String, dynamic>{'ids': instance.ids, 'notes': instance.notes};
