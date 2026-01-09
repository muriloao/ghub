import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/games_providers.dart';
import '../states/games_state.dart';
import '../../domain/usecases/sort_games.dart';

class GamesViewControls extends ConsumerWidget {
  const GamesViewControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesCount = ref.watch(gamesCountProvider);
    final viewMode = ref.watch(currentViewModeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Games Count
          Text(
            '$gamesCount Games',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade500,
            ),
          ),

          Row(
            children: [
              // Sort Button
              _buildSortButton(context, ref),
              const SizedBox(width: 8),

              // View Toggle
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF2d1b2e),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildViewToggleButton(
                      ref,
                      GameViewMode.grid,
                      Icons.grid_view,
                      viewMode == GameViewMode.grid,
                    ),
                    const SizedBox(width: 4),
                    _buildViewToggleButton(
                      ref,
                      GameViewMode.list,
                      Icons.view_list,
                      viewMode == GameViewMode.list,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton(
    WidgetRef ref,
    GameViewMode mode,
    IconData icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          ref.read(gamesNotifierProvider.notifier).toggleViewMode();
        }
      },
      child: Container(
        width: 36,
        height: 28,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFe225f4).withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? const Color(0xFFe225f4) : Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context, WidgetRef ref) {
    final sortCriteria = ref.watch(currentSortCriteriaProvider);
    final sortOrder = ref.watch(currentSortOrderProvider);

    return GestureDetector(
      onTap: () => _showSortMenu(context, ref),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2d1b2e),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              sortOrder == SortOrder.ascending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
              color: const Color(0xFFe225f4),
            ),
            const SizedBox(width: 4),
            Text(
              _getSortCriteriaText(sortCriteria),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFe225f4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortCriteriaText(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.name:
        return 'Nome';
      case SortCriteria.lastPlayed:
        return 'Jogado por último';
      case SortCriteria.releaseDate:
        return 'Data de lançamento';
      case SortCriteria.rating:
        return 'Avaliação';
      case SortCriteria.playtime:
        return 'Tempo de jogo';
    }
  }

  void _showSortMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SortBottomSheet();
      },
    );
  }
}

class SortBottomSheet extends ConsumerWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCriteria = ref.watch(currentSortCriteriaProvider);
    final currentOrder = ref.watch(currentSortOrderProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ordenar por',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sort Criteria Options
          _buildSortOption(
            context,
            ref,
            SortCriteria.name,
            'Nome',
            Icons.sort_by_alpha,
            currentCriteria == SortCriteria.name,
          ),
          _buildSortOption(
            context,
            ref,
            SortCriteria.lastPlayed,
            'Jogado por último',
            Icons.access_time,
            currentCriteria == SortCriteria.lastPlayed,
          ),
          _buildSortOption(
            context,
            ref,
            SortCriteria.releaseDate,
            'Data de lançamento',
            Icons.calendar_today,
            currentCriteria == SortCriteria.releaseDate,
          ),
          _buildSortOption(
            context,
            ref,
            SortCriteria.rating,
            'Avaliação',
            Icons.star,
            currentCriteria == SortCriteria.rating,
          ),
          _buildSortOption(
            context,
            ref,
            SortCriteria.playtime,
            'Tempo de jogo',
            Icons.schedule,
            currentCriteria == SortCriteria.playtime,
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.grey),
          const SizedBox(height: 16),

          // Sort Order
          const Text(
            'Ordem',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          _buildOrderOption(
            context,
            ref,
            SortOrder.ascending,
            'Crescente',
            Icons.arrow_upward,
            currentOrder == SortOrder.ascending,
          ),
          _buildOrderOption(
            context,
            ref,
            SortOrder.descending,
            'Decrescente',
            Icons.arrow_downward,
            currentOrder == SortOrder.descending,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    WidgetRef ref,
    SortCriteria criteria,
    String title,
    IconData icon,
    bool isSelected,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFe225f4) : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFFe225f4) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFFe225f4))
          : null,
      onTap: () {
        ref.read(gamesNotifierProvider.notifier).setSortCriteria(criteria);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildOrderOption(
    BuildContext context,
    WidgetRef ref,
    SortOrder order,
    String title,
    IconData icon,
    bool isSelected,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFe225f4) : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFFe225f4) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFFe225f4))
          : null,
      onTap: () {
        ref.read(gamesNotifierProvider.notifier).setSortOrder(order);
        Navigator.of(context).pop();
      },
    );
  }
}
