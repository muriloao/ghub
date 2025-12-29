import 'package:equatable/equatable.dart';

enum PlatformType {
  steam,
  xbox,
  playstation,
  epicGames,
  gog,
  nintendo,
  origin,
  uplay,
}

extension PlatformTypeExtension on PlatformType {
  String get name {
    switch (this) {
      case PlatformType.steam:
        return 'Steam';
      case PlatformType.xbox:
        return 'Xbox';
      case PlatformType.playstation:
        return 'PlayStation';
      case PlatformType.epicGames:
        return 'Epic Games';
      case PlatformType.gog:
        return 'GOG Galaxy';
      case PlatformType.nintendo:
        return 'Nintendo';
      case PlatformType.origin:
        return 'Origin';
      case PlatformType.uplay:
        return 'Uplay';
    }
  }

  String get description {
    switch (this) {
      case PlatformType.steam:
        return 'Games • Achievements • Friends';
      case PlatformType.xbox:
        return 'Games • Friends';
      case PlatformType.playstation:
        return 'Games • Trophies';
      case PlatformType.epicGames:
        return 'Games Only';
      case PlatformType.gog:
        return 'Games • Friends';
      case PlatformType.nintendo:
        return 'Games • Friends';
      case PlatformType.origin:
        return 'Games • Achievements';
      case PlatformType.uplay:
        return 'Games • Achievements';
    }
  }

  String get backgroundColor {
    switch (this) {
      case PlatformType.steam:
        return '#171a21';
      case PlatformType.xbox:
        return '#107C10';
      case PlatformType.playstation:
        return '#003791';
      case PlatformType.epicGames:
        return '#333333';
      case PlatformType.gog:
        return '#86328A';
      case PlatformType.nintendo:
        return '#E60012';
      case PlatformType.origin:
        return '#FF6600';
      case PlatformType.uplay:
        return '#0678BE';
    }
  }

  String get iconName {
    switch (this) {
      case PlatformType.steam:
        return 'sports_esports';
      case PlatformType.xbox:
        return 'X';
      case PlatformType.playstation:
        return 'PS';
      case PlatformType.epicGames:
        return 'change_history';
      case PlatformType.gog:
        return 'GOG';
      case PlatformType.nintendo:
        return 'gamepad';
      case PlatformType.origin:
        return 'circle';
      case PlatformType.uplay:
        return 'shield';
    }
  }
}

class GamingPlatform extends Equatable {
  final PlatformType type;
  final bool isConnected;
  final String? username;
  final DateTime? connectedAt;

  const GamingPlatform({
    required this.type,
    required this.isConnected,
    this.username,
    this.connectedAt,
  });

  GamingPlatform copyWith({
    PlatformType? type,
    bool? isConnected,
    String? username,
    DateTime? connectedAt,
  }) {
    return GamingPlatform(
      type: type ?? this.type,
      isConnected: isConnected ?? this.isConnected,
      username: username ?? this.username,
      connectedAt: connectedAt ?? this.connectedAt,
    );
  }

  @override
  List<Object?> get props => [type, isConnected, username, connectedAt];
}
