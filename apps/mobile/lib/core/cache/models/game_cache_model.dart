import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class GameCacheModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String platform;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final int playtimeMinutes;

  @HiveField(5)
  final DateTime? lastPlayed;

  @HiveField(6)
  final Map<String, dynamic> metadata;

  @HiveField(7)
  final DateTime cachedAt;

  @HiveField(8)
  final bool isFavorite;

  GameCacheModel({
    required this.id,
    required this.name,
    required this.platform,
    this.imageUrl,
    this.playtimeMinutes = 0,
    this.lastPlayed,
    this.metadata = const {},
    required this.cachedAt,
    this.isFavorite = false,
  });

  GameCacheModel copyWith({
    String? id,
    String? name,
    String? platform,
    String? imageUrl,
    int? playtimeMinutes,
    DateTime? lastPlayed,
    Map<String, dynamic>? metadata,
    DateTime? cachedAt,
    bool? isFavorite,
  }) {
    return GameCacheModel(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      imageUrl: imageUrl ?? this.imageUrl,
      playtimeMinutes: playtimeMinutes ?? this.playtimeMinutes,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      metadata: metadata ?? this.metadata,
      cachedAt: cachedAt ?? this.cachedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Verifica se o cache está expirado
  bool isExpired({Duration maxAge = const Duration(hours: 6)}) {
    return DateTime.now().difference(cachedAt) > maxAge;
  }

  /// Converte dados do Steam para GameCacheModel
  factory GameCacheModel.fromSteamGame(Map<String, dynamic> steamGame) {
    return GameCacheModel(
      id: steamGame['appid']?.toString() ?? '',
      name: steamGame['name'] ?? '',
      platform: 'steam',
      imageUrl: steamGame['img_icon_url'] != null
          ? 'https://media.steampowered.com/steamcommunity/public/images/apps/${steamGame['appid']}/${steamGame['img_icon_url']}.jpg'
          : null,
      playtimeMinutes: steamGame['playtime_forever'] ?? 0,
      lastPlayed: steamGame['rtime_last_played'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (steamGame['rtime_last_played'] as int) * 1000,
            )
          : null,
      metadata: Map<String, dynamic>.from(steamGame),
      cachedAt: DateTime.now(),
    );
  }

  /// Converte para Map para compatibilidade
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'imageUrl': imageUrl,
      'playtimeMinutes': playtimeMinutes,
      'lastPlayed': lastPlayed?.toIso8601String(),
      'metadata': metadata,
      'cachedAt': cachedAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}
