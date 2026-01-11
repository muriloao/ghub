import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghub_mobile/core/services/cache_service.dart';
import 'package:ghub_mobile/core/services/platform_sync_service.dart';
import 'package:ghub_mobile/core/theme/app_theme.dart';
import 'package:ghub_mobile/features/games/providers/games_cache_providers.dart';

/// Página para demonstrar e testar o sistema de cache
class CacheManagementPage extends ConsumerWidget {
  const CacheManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steamState = ref.watch(steamGamesNotifierProvider);
    final syncState = ref.watch(platformSyncNotifierProvider);
    final totalGamesCount = ref.watch(totalGamesCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Cache'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showCacheStats(context, ref),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estatísticas gerais
            _buildStatsCard(totalGamesCount),
            const SizedBox(height: 16),

            // Status das plataformas
            _buildPlatformStatusCard(
              'Steam',
              Icons.gamepad,
              Colors.blue,
              steamState,
              () => ref.read(steamGamesNotifierProvider.notifier).refresh(),
            ),
            const SizedBox(height: 16),

            // Seção de sincronização
            _buildSyncSection(syncState, ref),
            const SizedBox(height: 16),

            // Ações de cache
            _buildCacheActionsCard(context, ref),
            const SizedBox(height: 16),

            // Lista de jogos em cache
            _buildCachedGamesSection(steamState),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(int totalGames) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estatísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Jogos Total', '$totalGames', Icons.games),
                _buildStatItem('Plataformas', '2', Icons.devices),
                _buildStatItem('Cache', 'Ativo', Icons.storage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppTheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildPlatformStatusCard(
    String platformName,
    IconData icon,
    Color color,
    PlatformGamesState state,
    VoidCallback onRefresh,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    platformName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (state.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Atualizar',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jogos: ${state.games.length}'),
                      if (state.lastSync != null)
                        Text(
                          'Última sync: ${_formatDateTime(state.lastSync!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      if (state.error != null)
                        Text(
                          'Erro: ${state.error}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: state.error != null
                        ? Colors.red
                        : state.games.isEmpty
                        ? Colors.orange
                        : Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncSection(PlatformSyncState syncState, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sincronização',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: syncState.syncing.values.any((s) => s)
                        ? null
                        : () => ref
                              .read(platformSyncNotifierProvider.notifier)
                              .syncPlatform(Platform.steam),
                    icon: syncState.isSyncing(Platform.steam)
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_sync),
                    label: const Text('Sync Steam'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: syncState.syncing.values.any((s) => s)
                    ? null
                    : () => ref
                          .read(platformSyncNotifierProvider.notifier)
                          .syncAllPlatforms(),
                icon: const Icon(Icons.sync_alt),
                label: const Text('Sincronizar Tudo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheActionsCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ações de Cache',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _clearPlatformCache(context, ref, Platform.steam),
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Limpar Steam'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _clearAllCache(context, ref),
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Limpar Todo Cache'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCachedGamesSection(PlatformGamesState steamState) {
    final allGames = [...steamState.games];

    if (allGames.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('Nenhum jogo em cache')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jogos em Cache (${allGames.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...allGames.take(10).map((game) => _buildGameTile(game)),
            if (allGames.length > 10)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'E mais ${allGames.length - 10} jogos...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameTile(dynamic game) {
    String name;
    String? imageUrl;
    String platform;

    if (game.runtimeType.toString().contains('SteamGameModel')) {
      name = game.name;
      imageUrl = game.headerImage;
      platform = 'Steam';
    } else {
      name = game.name;
      imageUrl = game.imageUrl;
      platform = 'Xbox';
    }

    return ListTile(
      dense: true,
      leading: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.games, size: 20),
                ),
              ),
            )
          : Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.games, size: 20),
            ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        platform,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'agora mesmo';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else {
      return '${difference.inDays}d atrás';
    }
  }

  void _clearPlatformCache(
    BuildContext context,
    WidgetRef ref,
    Platform platform,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar cache do ${platform.name}'),
        content: Text(
          'Tem certeza que deseja limpar todos os dados em cache do ${platform.name}? '
          'Isso forçará uma nova sincronização na próxima vez que os dados forem necessários.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await PlatformCacheExtension.clearPlatformCache(platform);

              // Recarregar dados
              if (platform == Platform.steam) {
                ref.read(steamGamesNotifierProvider.notifier).refresh();
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Cache do ${platform.name} limpo com sucesso',
                    ),
                  ),
                );
              }
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void _clearAllCache(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar todo cache'),
        content: const Text(
          'Tem certeza que deseja limpar todos os dados em cache de todas as plataformas? '
          'Isso forçará uma nova sincronização completa na próxima vez que os dados forem necessários.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await PlatformCacheExtension.clearAllPlatformCache();

              // Recarregar dados de todas as plataformas
              ref.read(steamGamesNotifierProvider.notifier).refresh();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todo cache limpo com sucesso')),
                );
              }
            },
            child: const Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }

  void _showCacheStats(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estatísticas de Cache'),
        content: FutureBuilder(
          future: PlatformCacheExtension.getAllPlatformCache(),
          builder:
              (
                context,
                AsyncSnapshot<Map<Platform, PlatformCacheData?>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final caches = snapshot.data!;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in caches.entries)
                      _buildCacheStatItem(entry.key, entry.value),
                  ],
                );
              },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheStatItem(Platform platform, PlatformCacheData? cache) {
    final hasData = cache != null;
    final isExpired = hasData ? cache.isExpired() : true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            hasData ? Icons.storage : Icons.storage_outlined,
            size: 20,
            color: hasData
                ? (isExpired ? Colors.orange : Colors.green)
                : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  hasData
                      ? 'Jogos: ${cache.gamesData?.length ?? 0}'
                      : 'Sem dados',
                  style: const TextStyle(fontSize: 12),
                ),
                if (hasData && cache.lastSync != null)
                  Text(
                    'Sync: ${_formatDateTime(cache.lastSync!)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
