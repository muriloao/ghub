import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/gaming_platform.dart';

class PlatformCard extends StatelessWidget {
  final GamingPlatform platform;
  final VoidCallback? onConnect;
  final VoidCallback? onManage;

  const PlatformCard({
    super.key,
    required this.platform,
    this.onConnect,
    this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.1),
        ),
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
          // Platform icon
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse(
                          platform.type.backgroundColor.substring(1),
                          radix: 16,
                        ) +
                        0xFF000000,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: _buildPlatformIcon()),
              ),
              if (platform.isConnected)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppTheme.cardDark : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Platform info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform.type.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  platform.type.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Action button
          if (platform.isConnected)
            TextButton(
              onPressed: onManage,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                'Manage',
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Connect',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlatformIcon() {
    // For text-based icons
    if (platform.type.iconName == 'X' ||
        platform.type.iconName == 'PS' ||
        platform.type.iconName == 'GOG') {
      return Text(
        platform.type.iconName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // For Material Icons
    return Icon(_getIconData(), color: Colors.white, size: 24);
  }

  IconData _getIconData() {
    switch (platform.type.iconName) {
      case 'sports_esports':
        return Icons.sports_esports;
      case 'change_history':
        return Icons.change_history;
      case 'gamepad':
        return Icons.gamepad;
      case 'circle':
        return Icons.circle;
      case 'shield':
        return Icons.shield;
      default:
        return Icons.gamepad_outlined;
    }
  }
}
