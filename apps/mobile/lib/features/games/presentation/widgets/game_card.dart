import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/game.dart';
import 'favorite_button.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback? onTap;

  const GameCard({super.key, required this.game, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            context.push('${AppConstants.gameDetailRoute}/${game.id}');
          },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                _buildBackgroundImage(),

                // Favorite Button
                _buildFavoriteButton(),

                // Status Badge
                _buildStatusBadge(),

                // Trophy Icon (for completed games)
                if (game.isCompleted) _buildTrophyIcon(),

                // Game Information Overlay
                _buildGameInfoOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: 8,
      left: 8,
      child: FavoriteButton(game: game, size: 20),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2d1b2e),
        image: game.headerImageUrl != null
            ? DecorationImage(
                image: NetworkImage(game.headerImageUrl!),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Fallback será o container colorido
                },
              )
            : null,
      ),
      child: game.headerImageUrl == null
          ? Center(
              child: Icon(
                Icons.sports_esports,
                size: 48,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            )
          : null,
    );
  }

  Widget _buildStatusBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor().withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStatusColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_getStatusIcon() != null) ...[
              Icon(_getStatusIcon(), size: 12, color: _getStatusColor()),
              const SizedBox(width: 4),
            ],
            Text(
              _getStatusText(),
              style: TextStyle(
                color: _getStatusColor(),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrophyIcon() {
    return const Positioned(
      top: 8,
      left: 8,
      child: Icon(
        Icons.emoji_events,
        color: Colors.amber,
        size: 24,
        shadows: [
          Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
    );
  }

  Widget _buildGameInfoOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
              Colors.black,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Platform Icons & DLC Badge
            Row(
              children: [
                ..._buildPlatformIcons(),
                if (game.hasDLC) ...[
                  const SizedBox(width: 8),
                  Container(width: 1, height: 12, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Text(
                      '+ DLC',
                      style: TextStyle(
                        color: const Color(0xFFe225f4),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: const Color(
                              0xFFe225f4,
                            ).withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),

            // Game Name
            Text(
              game.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Game Info
            _buildGameInfo(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPlatformIcons() {
    final icons = <Widget>[];

    for (final platform in game.platforms) {
      IconData iconData;
      switch (platform) {
        case GamePlatform.pc:
          iconData = Icons.desktop_windows;
          break;
        case GamePlatform.playstation:
          iconData = Icons.sports_esports;
          break;
        case GamePlatform.xbox:
          iconData = Icons.gamepad;
          break;
        case GamePlatform.nintendo:
          iconData = Icons.gamepad;
          break;
        case GamePlatform.mobile:
          iconData = Icons.phone_android;
          break;
      }

      icons.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(iconData, size: 16, color: Colors.grey.shade300),
        ),
      );
    }

    return icons;
  }

  Widget _buildGameInfo() {
    // Progress bar for games with completion percentage
    if (game.completionPercentage != null && game.completionPercentage! > 0) {
      return Column(
        children: [
          const SizedBox(height: 4),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: game.completionPercentage! / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFe225f4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Last played info
    if (game.hasBeenPlayed) {
      return Text(
        'Last played ${game.lastPlayedFormatted}',
        style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
      );
    }

    // Status-specific info
    switch (game.status) {
      case GameStatus.wishlist:
        return Text(
          game.releaseDate ?? 'Coming soon',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
        );
      case GameStatus.backlog:
        return Text(
          'Not started',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
        );
      case GameStatus.completed:
        return const Text(
          '100% Completed',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        if (game.isPhysicalCopy) {
          return Text(
            'Physical Copy',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
          );
        }
        return const SizedBox.shrink();
    }
  }

  Color _getStatusColor() {
    switch (game.status) {
      case GameStatus.owned:
        return const Color(0xFFe225f4); // Primary color
      case GameStatus.subscription:
        return Colors.green;
      case GameStatus.wishlist:
        return Colors.pink;
      case GameStatus.backlog:
        return Colors.purple;
      case GameStatus.completed:
        return Colors.amber;
      case GameStatus.favorite:
        return Colors.red;
    }
  }

  IconData? _getStatusIcon() {
    switch (game.status) {
      case GameStatus.subscription:
        return Icons.verified;
      default:
        return null;
    }
  }

  String _getStatusText() {
    switch (game.status) {
      case GameStatus.owned:
        return 'OWNED';
      case GameStatus.subscription:
        return game.subscriptionService?.toUpperCase() ?? 'SUBSCRIPTION';
      case GameStatus.wishlist:
        return 'WISHLIST';
      case GameStatus.backlog:
        return 'BACKLOG';
      case GameStatus.completed:
        return 'COMPLETED';
      case GameStatus.favorite:
        return 'FAVORITE';
    }
  }
}
