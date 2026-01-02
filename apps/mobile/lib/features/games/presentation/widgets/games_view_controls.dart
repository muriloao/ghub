import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/games_providers.dart';
import '../states/games_state.dart';

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
              ? const Color(0xFFe225f4).withOpacity(0.2)
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
}
