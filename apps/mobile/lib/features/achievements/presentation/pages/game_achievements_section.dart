import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/achievement_providers.dart';
import '../widgets/achievement_card.dart';
import '../widgets/achievement_filters.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/achievement_stats.dart' as achievementStatsWidget;

/// Widget principal da seção de achievements de um jogo
class GameAchievementsSection extends ConsumerWidget {
  final String appId;
  final String gameName;

  const GameAchievementsSection({
    super.key,
    required this.appId,
    required this.gameName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final achievements = ref.watch(gameAchievementsProvider(appId));
    final isLoading = ref.watch(gameAchievementsLoadingProvider(appId));
    final error = ref.watch(gameAchievementsErrorProvider(appId));
    final stats = ref.watch(gameAchievementsStatsProvider(appId));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Conquistas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),

                if (!isLoading && error == null) ...[
                  _buildCompareButton(isDarkMode),
                ],
              ],
            ),
          ),

          // Error State
          if (error != null) ...[
            _buildErrorState(error, isDarkMode, ref),
          ]
          // Loading State
          else if (isLoading) ...[
            _buildLoadingState(),
          ]
          // No Achievements State
          else if (achievements.isEmpty && stats.total == 0) ...[
            _buildNoAchievementsState(isDarkMode),
          ]
          // Success State
          else ...[
            // Stats Section
            achievementStatsWidget.AchievementStats(appId: appId),

            // Filters Section
            AchievementFilters(appId: appId),

            const SizedBox(height: 16),

            // Achievements List
            if (achievements.isEmpty) ...[
              _buildNoFilteredAchievementsState(isDarkMode, ref),
            ] else ...[
              _buildAchievementsList(achievements, isDarkMode),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCompareButton(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        // TODO: Implementar comparação com amigos
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group,
              size: 16,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              'Comparar com Amigos',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDarkMode, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2d1b2e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 12),
          Text(
            'Erro ao Carregar Conquistas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(gameAchievementsNotifierProvider(appId).notifier)
                  .refresh(appId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Carregando conquistas...',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAchievementsState(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2d1b2e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 48,
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Sem Conquistas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Este jogo não possui conquistas disponíveis ou elas estão privadas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFilteredAchievementsState(bool isDarkMode, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2d1b2e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhuma Conquista Encontrada',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nenhuma conquista corresponde ao filtro selecionado.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              ref
                  .read(gameAchievementsNotifierProvider(appId).notifier)
                  .setFilter(AchievementFilter.all);
            },
            child: const Text(
              'Mostrar Todas',
              style: TextStyle(color: AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(List achievements, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ...achievements.map(
            (achievement) => AchievementCard(
              achievement: achievement,
              onTap: () {
                // TODO: Mostrar detalhes do achievement
                _showAchievementDetails(achievement);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAchievementDetails(achievement) {
    // TODO: Implementar modal ou página de detalhes do achievement
    print('Mostrar detalhes de: ${achievement.name}');
  }
}
