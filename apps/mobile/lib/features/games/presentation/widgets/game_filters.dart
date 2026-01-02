import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/games_providers.dart';
import '../states/games_state.dart';

class GameFilters extends ConsumerWidget {
  final String steamId;

  const GameFilters({super.key, required this.steamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(currentGameFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildFilterChip(
            context,
            ref,
            GameFilter.all,
            'All',
            Icons.apps,
            currentFilter == GameFilter.all,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context,
            ref,
            GameFilter.pc,
            'PC',
            Icons.desktop_windows,
            currentFilter == GameFilter.pc,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context,
            ref,
            GameFilter.console,
            'Console',
            Icons.sports_esports,
            currentFilter == GameFilter.console,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context,
            ref,
            GameFilter.favorites,
            'Favorites',
            Icons.favorite,
            currentFilter == GameFilter.favorites,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context,
            ref,
            GameFilter.backlog,
            'Backlog',
            Icons.schedule,
            currentFilter == GameFilter.backlog,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context,
            ref,
            GameFilter.completed,
            'Completed',
            Icons.emoji_events,
            currentFilter == GameFilter.completed,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context,
            ref,
            GameFilter.recentlyPlayed,
            'Recent',
            Icons.access_time,
            currentFilter == GameFilter.recentlyPlayed,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref,
    GameFilter filter,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(gamesNotifierProvider.notifier).setFilter(filter);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFe225f4)
              : Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2d1b2e)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? null
              : Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade100,
                  width: 1,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFe225f4).withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade300
                  : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade300
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
