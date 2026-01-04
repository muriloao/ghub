import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/gaming_platform.dart';
import '../providers/integrations_providers.dart';
import '../../../../core/theme/app_theme.dart';

class PlatformCard extends ConsumerWidget {
  final GamingPlatform platform;
  final VoidCallback? onTap;

  const PlatformCard({Key? key, required this.platform, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: platform.isConnecting ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: platform.isConnected
                ? AppTheme.primary.withOpacity(0.3)
                : (isDarkMode
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.1)),
            width: platform.isConnected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildPlatformIcon(isDarkMode),
            const SizedBox(width: 16),
            Expanded(child: _buildPlatformInfo(theme)),
            const SizedBox(width: 12),
            _buildActionButton(theme, ref, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(bool isDarkMode) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: platform.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: platform.backgroundColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: platform.logoText != null
                ? Text(
                    platform.logoText!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : Icon(platform.icon, color: Colors.white, size: 24),
          ),
        ),
        if (platform.isConnected)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDarkMode ? AppTheme.cardDark : Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 8),
            ),
          ),
      ],
    );
  }

  Widget _buildPlatformInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          platform.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          platform.description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.4)
                : Colors.grey.shade500,
          ),
        ),
        if (platform.isConnected && platform.connectedUsername != null) ...[
          const SizedBox(height: 4),
          Text(
            'Connected as ${platform.connectedUsername}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(ThemeData theme, WidgetRef ref, bool isDarkMode) {
    if (platform.isConnecting) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.primary,
          ),
        ),
      );
    }

    if (platform.isConnected) {
      return TextButton(
        onPressed: () => _showManageDialog(ref),
        style: TextButton.styleFrom(
          foregroundColor: isDarkMode
              ? Colors.white.withOpacity(0.3)
              : Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: const Text(
          'Manage',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => ref
          .read(integrationsNotifierProvider.notifier)
          .connectPlatform(platform.id),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        shadowColor: AppTheme.primary.withOpacity(0.3),
      ),
      child: const Text(
        'Connect',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  void _showManageDialog(WidgetRef ref) {
    // TODO: Show manage platform dialog
    // For now, just disconnect
    ref
        .read(integrationsNotifierProvider.notifier)
        .disconnectPlatform(platform.id);
  }
}
