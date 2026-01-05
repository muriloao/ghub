import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../games/data/models/steam_achievement_model.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget para exibir um achievement individual
class AchievementCard extends ConsumerWidget {
  final CompleteSteamAchievementModel achievement;
  final VoidCallback? onTap;

  const AchievementCard({super.key, required this.achievement, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDarkMode ? const Color(0xFF2d1b2e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: achievement.isUnlocked
                    ? AppTheme.primary.withOpacity(0.3)
                    : (isDarkMode
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.2)),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Achievement Icon
                _buildAchievementIcon(isDarkMode),

                const SizedBox(width: 16),

                // Achievement Info
                Expanded(child: _buildAchievementInfo(isDarkMode)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementIcon(bool isDarkMode) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Background for loading
            Container(color: isDarkMode ? Colors.black : Colors.grey.shade100),

            // Achievement Icon
            CachedNetworkImage(
              imageUrl: achievement.iconUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                child: Icon(
                  Icons.emoji_events,
                  color: isDarkMode
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                  size: 24,
                ),
              ),
              colorBlendMode: achievement.isUnlocked
                  ? null
                  : BlendMode.saturation,
              color: achievement.isUnlocked ? null : Colors.grey,
            ),

            // Overlay for locked achievements
            if (!achievement.isUnlocked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Rarity Badge
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                achievement.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: achievement.isUnlocked
                      ? (isDarkMode ? Colors.white : Colors.black87)
                      : (isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade600),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 8),

            // Rarity Badge
            _buildRarityBadge(isDarkMode),
          ],
        ),

        const SizedBox(height: 4),

        // Description
        if (achievement.description.isNotEmpty) ...[
          Text(
            achievement.description,
            style: TextStyle(
              fontSize: 12,
              color: achievement.isUnlocked
                  ? (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700)
                  : (isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
        ],

        // Progress Bar and Unlock Info
        _buildProgressSection(isDarkMode),
      ],
    );
  }

  Widget _buildRarityBadge(bool isDarkMode) {
    Color badgeColor;
    Color textColor;

    switch (achievement.rarity) {
      case AchievementRarity.rare:
        badgeColor = AppTheme.primary.withOpacity(0.1);
        textColor = AppTheme.primary;
        break;
      case AchievementRarity.uncommon:
        badgeColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case AchievementRarity.common:
        badgeColor = isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.withOpacity(0.1);
        textColor = isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        achievement.rarity.displayName,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProgressSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF211022) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: achievement.progress,
            child: Container(
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? AppTheme.primary
                    : Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
                boxShadow: achievement.isUnlocked
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.6),
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),

        // Unlock Date or Global Percentage
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (achievement.isUnlocked && achievement.unlockDate != null) ...[
              Text(
                _formatUnlockDate(achievement.unlockDate!),
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
              ),
            ] else ...[
              Text(
                'Não desbloqueado',
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode
                      ? Colors.grey.shade500
                      : Colors.grey.shade500,
                ),
              ),
            ],

            // Global Percentage
            if (achievement.globalPercentage != null) ...[
              Text(
                '${achievement.globalPercentage!.toStringAsFixed(1)}% dos jogadores',
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode
                      ? Colors.grey.shade500
                      : Colors.grey.shade500,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatUnlockDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return 'Há ${difference.inMinutes} min';
      }
      return 'Há ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays}d';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Há ${weeks}sem';
    } else {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      return '$day/$month/$year';
    }
  }
}
