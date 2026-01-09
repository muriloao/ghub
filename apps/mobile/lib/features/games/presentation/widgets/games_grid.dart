import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'game_card.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/games_providers.dart';
import '../states/games_state.dart';
import '../../domain/entities/game.dart';

class GamesGrid extends ConsumerWidget {
  const GamesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesListProvider);
    final viewMode = ref.watch(currentViewModeProvider);
    final isLoading = ref.watch(isLoadingGamesProvider);

    if (isLoading && games.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFe225f4)),
        ),
      );
    }

    if (games.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_esports_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No games found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFe225f4),
      onRefresh: () async {
        // Recarregar games - implementar reload geral quando não há steamId específico
        // Por enquanto, apenas simular refresh
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: viewMode == GameViewMode.grid
          ? _buildGridView(games)
          : _buildListView(games),
    );
  }

  Widget _buildGridView(List<Game> games) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return GameCard(game: game, onTap: () => _onGameTap(context, game));
      },
    );
  }

  Widget _buildListView(List<Game> games) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: games.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildListItem(context, game);
      },
    );
  }

  Widget _buildListItem(BuildContext context, Game game) {
    return GestureDetector(
      onTap: () => _onGameTap(context, game),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2d1b2e)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Game Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2d1b2e),
                  image: game.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(game.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: game.imageUrl == null
                    ? const Icon(
                        Icons.sports_esports,
                        color: Colors.white24,
                        size: 32,
                      )
                    : null,
              ),
            ),

            // Game Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Game Name
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Platform Icons
                    Row(
                      children: game.platforms.take(3).map((platform) {
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

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            iconData,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                        );
                      }).toList(),
                    ),

                    const Spacer(),

                    // Game Status
                    Text(
                      game.hasBeenPlayed
                          ? '${game.playtimeFormatted} • ${game.lastPlayedFormatted}'
                          : 'Not played',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Status Badge
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(game.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(game.status).withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  _getStatusText(game.status),
                  style: TextStyle(
                    color: _getStatusColor(game.status),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onGameTap(BuildContext context, Game game) {
    context.push('${AppConstants.gameDetailRoute}/${game.id}');
  }

  Color _getStatusColor(GameStatus status) {
    switch (status) {
      case GameStatus.owned:
        return const Color(0xFFe225f4);
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

  String _getStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.owned:
        return 'OWNED';
      case GameStatus.subscription:
        return 'SUBSCRIPTION';
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
