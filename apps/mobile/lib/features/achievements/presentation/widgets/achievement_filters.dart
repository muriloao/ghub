import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/achievement_providers.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget para os filtros de achievements
class AchievementFilters extends ConsumerWidget {
  final String appId;

  const AchievementFilters({super.key, required this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final currentFilter = ref.watch(gameAchievementsFilterProvider(appId));
    final stats = ref.watch(gameAchievementsStatsProvider(appId));

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AchievementFilter.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = AchievementFilter.values[index];
          final isSelected = currentFilter == filter;

          return _buildFilterChip(
            filter: filter,
            isSelected: isSelected,
            isDarkMode: isDarkMode,
            stats: stats,
            onTap: () {
              ref
                  .read(gameAchievementsNotifierProvider(appId).notifier)
                  .setFilter(filter);
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required AchievementFilter filter,
    required bool isSelected,
    required bool isDarkMode,
    required AchievementStats stats,
    required VoidCallback onTap,
  }) {
    // Get count for filter
    int count = 0;
    switch (filter) {
      case AchievementFilter.all:
        count = stats.total;
        break;
      case AchievementFilter.unlocked:
        count = stats.unlocked;
        break;
      case AchievementFilter.locked:
        count = stats.locked;
        break;
      case AchievementFilter.rare:
        count = stats.rare;
        break;
      case AchievementFilter.hidden:
        count = 0; // Implementar se necessário
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.1)
              : (isDarkMode ? const Color(0xFF2d1b2e) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : (isDarkMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filter.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppTheme.primary
                    : (isDarkMode ? Colors.white : Colors.black87),
              ),
            ),

            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary
                      : (isDarkMode
                            ? Colors.grey.shade700
                            : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
