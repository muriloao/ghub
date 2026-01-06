import 'package:equatable/equatable.dart';
import '../../../onboarding/domain/entities/gaming_platform.dart';

enum GameStatus {
  owned,
  subscription, // GamePass, PS Plus, etc.
  wishlist,
  backlog,
  completed,
  favorite,
}

enum GamePlatform { pc, playstation, xbox, nintendo, mobile }

class Game extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final String? headerImageUrl;
  final GameStatus status;
  final List<GamePlatform> platforms;
  final int? playtimeForever; // em minutos
  final int? playtime2Weeks; // em minutos
  final DateTime? lastPlayed;
  final bool hasDLC;
  final bool isCompleted;
  final double? completionPercentage;
  final String? subscriptionService; // GamePass, PS Plus, etc.
  final bool isPhysicalCopy;
  final String? releaseDate;
  final List<String>? genres;
  final String? developer;
  final String? publisher;
  final double? rating;
  final String? description;
  final PlatformType?
  sourcePlatform; // Plataforma de origem (Steam, Epic, etc.)

  const Game({
    required this.id,
    required this.name,
    this.imageUrl,
    this.headerImageUrl,
    required this.status,
    required this.platforms,
    this.playtimeForever,
    this.playtime2Weeks,
    this.lastPlayed,
    this.hasDLC = false,
    this.isCompleted = false,
    this.completionPercentage,
    this.subscriptionService,
    this.isPhysicalCopy = false,
    this.releaseDate,
    this.genres,
    this.developer,
    this.publisher,
    this.rating,
    this.description,
    this.sourcePlatform,
  });

  bool get hasBeenPlayed => playtimeForever != null && playtimeForever! > 0;

  bool get recentlyPlayed => playtime2Weeks != null && playtime2Weeks! > 0;

  String get playtimeFormatted {
    if (playtimeForever == null || playtimeForever == 0) return 'Not played';

    final hours = playtimeForever! ~/ 60;
    if (hours < 1) return '${playtimeForever}min';
    if (hours < 100) return '${hours}h';
    return '${hours}h';
  }

  String get lastPlayedFormatted {
    if (lastPlayed == null) return 'Never played';

    final now = DateTime.now();
    final difference = now.difference(lastPlayed!);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}min ago';
      }
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '${weeks}w ago';
    }

    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '${months}mo ago';
    }

    final years = difference.inDays ~/ 365;
    return '${years}y ago';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    headerImageUrl,
    status,
    platforms,
    playtimeForever,
    playtime2Weeks,
    lastPlayed,
    hasDLC,
    isCompleted,
    completionPercentage,
    subscriptionService,
    isPhysicalCopy,
    releaseDate,
    genres,
    developer,
    publisher,
    rating,
    description,
    sourcePlatform,
  ];
}
