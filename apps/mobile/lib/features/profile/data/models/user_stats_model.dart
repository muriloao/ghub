import '../../domain/entities/profile_entities.dart';

class UserStatsModel extends UserStats {
  const UserStatsModel({
    required super.gamesCount,
    required super.trophiesCount,
    required super.totalPlayTime,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      gamesCount: json['gamesCount'] as int? ?? 0,
      trophiesCount: json['trophiesCount'] as int? ?? 0,
      totalPlayTime: json['totalPlayTime'] as String? ?? '0h',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gamesCount': gamesCount,
      'trophiesCount': trophiesCount,
      'totalPlayTime': totalPlayTime,
    };
  }

  @override
  UserStatsModel copyWith({
    int? gamesCount,
    int? trophiesCount,
    String? totalPlayTime,
  }) {
    return UserStatsModel(
      gamesCount: gamesCount ?? this.gamesCount,
      trophiesCount: trophiesCount ?? this.trophiesCount,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
    );
  }
}
