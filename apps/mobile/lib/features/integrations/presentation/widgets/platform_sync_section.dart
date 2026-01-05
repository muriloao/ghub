import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/cache_service.dart';
import '../../../../core/services/platform_sync_service.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget para botão de sincronização de uma plataforma
class PlatformSyncButton extends ConsumerWidget {
  final Platform platform;
  final String platformName;
  final IconData platformIcon;
  final Color platformColor;
  final bool isConnected;

  const PlatformSyncButton({
    super.key,
    required this.platform,
    required this.platformName,
    required this.platformIcon,
    required this.platformColor,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSyncing = ref.watch(isSyncingProvider(platform));
    final syncResult = ref.watch(syncResultProvider(platform));
    final hasError = ref.watch(hasErrorProvider(platform));

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com ícone e nome da plataforma
            Row(
              children: [
                Icon(platformIcon, color: platformColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    platformName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Status indicator
                _buildStatusIndicator(isConnected, hasError, isSyncing),
              ],
            ),
            const SizedBox(height: 12),

            // Status da última sincronização
            if (syncResult != null) ...[
              _buildLastSyncInfo(syncResult),
              const SizedBox(height: 12),
            ],

            // Botão de sincronização
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isConnected && !isSyncing
                    ? () => _handleSync(ref)
                    : null,
                icon: isSyncing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Icon(isConnected ? Icons.sync : Icons.link_off, size: 18),
                label: Text(_getButtonText(isConnected, isSyncing)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConnected ? platformColor : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(
    bool isConnected,
    bool hasError,
    bool isSyncing,
  ) {
    if (isSyncing) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (!isConnected) {
      return const Icon(Icons.link_off, color: Colors.grey, size: 16);
    }

    if (hasError) {
      return const Icon(Icons.error_outline, color: Colors.red, size: 16);
    }

    return const Icon(
      Icons.check_circle_outline,
      color: Colors.green,
      size: 16,
    );
  }

  Widget _buildLastSyncInfo(SyncResult result) {
    final timeAgo = _getTimeAgo(result.syncTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: result.success
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: result.success
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            result.success ? Icons.check_circle : Icons.error,
            size: 16,
            color: result.success ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.success
                      ? 'Sincronizado com sucesso'
                      : 'Erro na sincronização',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: result.success
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                Text(
                  result.success && result.gamesCount != null
                      ? '$timeAgo • ${result.gamesCount} jogos'
                      : result.error != null
                      ? result.error!
                      : timeAgo,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(bool isConnected, bool isSyncing) {
    if (isSyncing) {
      return 'Sincronizando...';
    }

    if (!isConnected) {
      return 'Não conectado';
    }

    return 'Sincronizar dados';
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else {
      return '${difference.inDays}d atrás';
    }
  }

  void _handleSync(WidgetRef ref) {
    final notifier = ref.read(platformSyncNotifierProvider.notifier);
    notifier.forceSync(platform);

    // Mostrar feedback
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(
        content: Text('Iniciando sincronização do $platformName...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Widget para seção completa de sincronização de plataformas
class PlatformSyncSection extends ConsumerWidget {
  const PlatformSyncSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(platformSyncNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header da seção
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.sync, color: AppTheme.primary, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Sincronização de dados',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // Botão para sincronizar tudo
              TextButton.icon(
                onPressed: _isAnyPlatformSyncing(syncState)
                    ? null
                    : () => _handleSyncAll(ref),
                icon: _isAnyPlatformSyncing(syncState)
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync_alt),
                label: Text(
                  _isAnyPlatformSyncing(syncState)
                      ? 'Sincronizando...'
                      : 'Sincronizar tudo',
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Mantenha seus dados de jogos sempre atualizados',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),

        const SizedBox(height: 16),

        // Lista de plataformas
        FutureBuilder<Map<Platform, bool>>(
          future: _getConnectedPlatforms(),
          builder: (context, snapshot) {
            final connectedPlatforms = snapshot.data ?? {};

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Steam
                  PlatformSyncButton(
                    platform: Platform.steam,
                    platformName: 'Steam',
                    platformIcon: Icons.gamepad,
                    platformColor: const Color(0xFF1B2838),
                    isConnected: connectedPlatforms[Platform.steam] ?? false,
                  ),
                  const SizedBox(height: 12),

                  // Xbox
                  PlatformSyncButton(
                    platform: Platform.xbox,
                    platformName: 'Xbox Live',
                    platformIcon: Icons.sports_esports,
                    platformColor: const Color(0xFF107C10),
                    isConnected: connectedPlatforms[Platform.xbox] ?? false,
                  ),
                  const SizedBox(height: 12),

                  // Epic Games (quando implementado)
                  PlatformSyncButton(
                    platform: Platform.epic,
                    platformName: 'Epic Games',
                    platformIcon: Icons.videogame_asset,
                    platformColor: const Color(0xFF313131),
                    isConnected: connectedPlatforms[Platform.epic] ?? false,
                  ),
                ],
              ),
            );
          },
        ),

        // Error global se existir
        if (syncState.globalError != null) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        syncState.globalError!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(platformSyncNotifierProvider.notifier)
                            .clearError();
                      },
                      icon: const Icon(Icons.close, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  bool _isAnyPlatformSyncing(PlatformSyncState state) {
    return state.syncing.values.any((syncing) => syncing);
  }

  void _handleSyncAll(WidgetRef ref) {
    final notifier = ref.read(platformSyncNotifierProvider.notifier);
    notifier.syncAllPlatforms();

    ScaffoldMessenger.of(ref.context).showSnackBar(
      const SnackBar(
        content: Text('Iniciando sincronização de todas as plataformas...'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<Map<Platform, bool>> _getConnectedPlatforms() async {
    final cachedUser = await CacheService.getCachedUserData();

    return {
      Platform.steam: cachedUser?.steamId != null,
      Platform.xbox: cachedUser?.authToken != null,
      Platform.epic: false, // Quando implementado
    };
  }
}
