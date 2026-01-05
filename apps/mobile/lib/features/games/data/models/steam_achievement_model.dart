import 'package:json_annotation/json_annotation.dart';

part 'steam_achievement_model.g.dart';

/// Modelo de Achievement individual da Steam
@JsonSerializable()
class SteamAchievementModel {
  @JsonKey(name: 'apiname')
  final String apiName;

  @JsonKey(name: 'achieved')
  final int achieved; // 1 se desbloqueado, 0 se não

  @JsonKey(name: 'unlocktime')
  final int unlockTime; // Unix timestamp quando foi desbloqueado

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  const SteamAchievementModel({
    required this.apiName,
    required this.achieved,
    required this.unlockTime,
    this.name,
    this.description,
  });

  factory SteamAchievementModel.fromJson(Map<String, dynamic> json) =>
      _$SteamAchievementModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamAchievementModelToJson(this);

  /// Retorna true se o achievement foi desbloqueado
  bool get isUnlocked => achieved == 1;

  /// Retorna a data de desbloqueio (se disponível)
  DateTime? get unlockDate {
    if (unlockTime == 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(unlockTime * 1000);
  }
}

/// Modelo de schema de Achievement (informações globais do achievement)
@JsonSerializable()
class SteamAchievementSchemaModel {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'displayName')
  final String displayName;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'icon')
  final String iconUrl;

  @JsonKey(name: 'icongray')
  final String iconGrayUrl;

  @JsonKey(name: 'hidden')
  final int? hidden;

  @JsonKey(name: 'defaultvalue')
  final int? defaultValue;

  const SteamAchievementSchemaModel({
    required this.name,
    required this.displayName,
    this.description,
    required this.iconUrl,
    required this.iconGrayUrl,
    this.hidden,
    this.defaultValue,
  });

  factory SteamAchievementSchemaModel.fromJson(Map<String, dynamic> json) =>
      _$SteamAchievementSchemaModelFromJson(json);

  Map<String, dynamic> toJson() => _$SteamAchievementSchemaModelToJson(this);

  /// Retorna true se o achievement está oculto por padrão
  bool get isHidden => hidden == 1;
}

/// Modelo completo combinando achievement do usuário com schema
class CompleteSteamAchievementModel {
  final SteamAchievementModel userAchievement;
  final SteamAchievementSchemaModel schema;
  final double?
  globalPercentage; // Percentual global de jogadores que têm o achievement

  const CompleteSteamAchievementModel({
    required this.userAchievement,
    required this.schema,
    this.globalPercentage,
  });

  /// Nome do achievement
  String get name => schema.displayName.isNotEmpty
      ? schema.displayName
      : userAchievement.name ?? schema.name;

  /// Descrição do achievement
  String get description =>
      schema.description ?? userAchievement.description ?? '';

  /// URL do ícone (colorido se desbloqueado, cinza se não)
  String get iconUrl =>
      userAchievement.isUnlocked ? schema.iconUrl : schema.iconGrayUrl;

  /// Se foi desbloqueado
  bool get isUnlocked => userAchievement.isUnlocked;

  /// Data de desbloqueio
  DateTime? get unlockDate => userAchievement.unlockDate;

  /// Raridade baseada no percentual global
  AchievementRarity get rarity {
    if (globalPercentage == null) return AchievementRarity.common;

    if (globalPercentage! < 5.0) return AchievementRarity.rare;
    if (globalPercentage! < 25.0) return AchievementRarity.uncommon;
    return AchievementRarity.common;
  }

  /// Progresso (0.0 a 1.0) - para a maioria será 0.0 ou 1.0
  double get progress => isUnlocked ? 1.0 : 0.0;
}

/// Resposta da API de achievements do usuário
@JsonSerializable()
class SteamPlayerAchievementsResponse {
  @JsonKey(name: 'steamID')
  final String steamId;

  @JsonKey(name: 'gameName')
  final String gameName;

  @JsonKey(name: 'achievements')
  final List<SteamAchievementModel> achievements;

  @JsonKey(name: 'success')
  final bool success;

  const SteamPlayerAchievementsResponse({
    required this.steamId,
    required this.gameName,
    required this.achievements,
    required this.success,
  });

  factory SteamPlayerAchievementsResponse.fromJson(Map<String, dynamic> json) =>
      _$SteamPlayerAchievementsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SteamPlayerAchievementsResponseToJson(this);
}

/// Resposta da API de schema de achievements
@JsonSerializable()
class SteamAchievementSchemaResponse {
  @JsonKey(name: 'gameName')
  final String gameName;

  @JsonKey(name: 'gameVersion')
  final String gameVersion;

  @JsonKey(name: 'availableGameStats')
  final Map<String, dynamic> availableGameStats;

  const SteamAchievementSchemaResponse({
    required this.gameName,
    required this.gameVersion,
    required this.availableGameStats,
  });

  factory SteamAchievementSchemaResponse.fromJson(Map<String, dynamic> json) =>
      _$SteamAchievementSchemaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SteamAchievementSchemaResponseToJson(this);

  /// Extrai lista de achievements do schema
  List<SteamAchievementSchemaModel> get achievements {
    final achievementsList = availableGameStats['achievements'];
    if (achievementsList == null) return [];

    return (achievementsList as List)
        .map((a) => SteamAchievementSchemaModel.fromJson(a))
        .toList();
  }
}

/// Resposta da API de percentuais globais de achievements
@JsonSerializable()
class SteamGlobalAchievementPercentagesResponse {
  @JsonKey(name: 'achievements')
  final List<Map<String, dynamic>> achievements;

  const SteamGlobalAchievementPercentagesResponse({required this.achievements});

  factory SteamGlobalAchievementPercentagesResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$SteamGlobalAchievementPercentagesResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SteamGlobalAchievementPercentagesResponseToJson(this);

  /// Mapa de achievement name -> percentual
  Map<String, double> get percentageMap {
    final Map<String, double> result = {};
    for (final achievement in achievements) {
      final name = achievement['name'] as String?;
      final percent = achievement['percent'] as double?;
      if (name != null && percent != null) {
        result[name] = percent;
      }
    }
    return result;
  }
}

/// Enum para raridade de achievements
enum AchievementRarity { common, uncommon, rare }

extension AchievementRarityExtension on AchievementRarity {
  String get displayName {
    switch (this) {
      case AchievementRarity.common:
        return 'COMMON';
      case AchievementRarity.uncommon:
        return 'UNCOMMON';
      case AchievementRarity.rare:
        return 'RARE';
    }
  }

  String get displayNamePt {
    switch (this) {
      case AchievementRarity.common:
        return 'COMUM';
      case AchievementRarity.uncommon:
        return 'INCOMUM';
      case AchievementRarity.rare:
        return 'RARO';
    }
  }
}
