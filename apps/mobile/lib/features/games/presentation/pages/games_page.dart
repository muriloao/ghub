import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../integrations/presentation/providers/integrations_providers.dart';
import '../../../integrations/presentation/providers/steam_connection_provider.dart';
import '../../../../core/services/platform_connections_service.dart';
import '../widgets/game_filters.dart';
import '../widgets/games_search_bar.dart';
import '../widgets/games_view_controls.dart';
import '../widgets/games_grid.dart';
import '../providers/games_providers.dart';
import '../../../../core/constants/app_constants.dart';

class GamesPage extends ConsumerStatefulWidget {
  const GamesPage({super.key});

  @override
  ConsumerState<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends ConsumerState<GamesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoRestoreSteamAndLoadGames();
    });
  }

  void _autoRestoreSteamAndLoadGames() async {
    // Auto-restaurar conexão Steam se houver tokens salvos
    final steamNotifier = ref.read(steamConnectionProvider.notifier);

    if (await steamNotifier.hasValidSavedTokens()) {
      await steamNotifier.restoreConnection();

      // Aguardar um frame para garantir que o state foi atualizado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final steamState = ref.read(steamConnectionProvider);
        if (steamState.isConnected && steamState.steamId != null) {
          _loadSteamGames(steamState.steamId!);
        }
      });
    }

    // Também carregar de outras plataformas conectadas (método legado)
    await _loadConnectedPlatformGames();
  }

  Future<void> _loadConnectedPlatformGames() async {
    final connectedPlatforms =
        await PlatformConnectionsService.getConnections();

    // Carregar jogos de cada plataforma conectada
    for (final platformConnection in connectedPlatforms) {
      switch (platformConnection.platformId) {
        case 'steam':
          _loadSteamGamesFromPlatform(platformConnection);
          break;
      }
    }
  }

  void _loadSteamGamesFromPlatform(PlatformConnectionData platformConnection) {
    // Extrair Steam ID dos dados da plataforma conectada
    final steamId =
        platformConnection.metadata['steamId'] ?? platformConnection.userId;
    if (steamId != null) {
      _loadSteamGames(steamId);
    }
  }

  void _loadSteamGames(String steamId) {
    print('🎮 Carregando jogos Steam para ID: $steamId');
    ref.read(gamesNotifierProvider.notifier).loadGames(steamId);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final hasError = ref.watch(hasGamesErrorProvider);
    final errorMessage = ref.watch(gamesErrorMessageProvider);
    final gamesState = ref.watch(gamesNotifierProvider);

    // Listen for connected platforms changes
    ref.listen(connectedPlatformsProvider, (previous, next) {
      if (previous != next && next.isNotEmpty) {
        _loadConnectedPlatformGames();
      }
    });

    // Listen for Steam connection changes
    ref.listen(steamConnectionProvider, (previous, next) {
      // Se Steam conectou com sucesso e temos Steam ID, carregar jogos
      if (previous?.status != SteamConnectionStatus.success &&
          next.status == SteamConnectionStatus.success &&
          next.steamId != null) {
        _loadSteamGames(next.steamId!);
      }
    });

    if (gamesState.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF211022)
            : const Color(0xFFf8f5f8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFe225f4)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Carregando jogos...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  final steamState = ref.watch(steamConnectionProvider);
                  if (steamState.isConnected && steamState.userData != null) {
                    return Text(
                      'Sincronizando com Steam API...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF211022)
          : const Color(0xFFf8f5f8),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context, authState),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const GamesSearchBar(),
            ),
            const SizedBox(height: 16),

            // Steam Connection Status
            _buildSteamConnectionStatus(),

            // Filters & Controls
            Column(
              children: [
                // Horizontal Filter Chips
                const GameFilters(),
                const SizedBox(height: 16),

                // View Toggle & Count
                const GamesViewControls(),
              ],
            ),
            const SizedBox(height: 8),

            // Game Grid
            Expanded(
              child: !hasError
                  ? const GamesGrid()
                  : _buildErrorState(errorMessage),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      // bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader(BuildContext context, AuthState authState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF211022).withValues(alpha: 0.95)
            : const Color(0xFFf8f5f8).withValues(alpha: 0.95),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Title
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFe225f4).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sports_esports,
                  color: Color(0xFFe225f4),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    authState is AuthAuthenticated
                        ? authState.user.name ?? ''
                        : 'Unified Library',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Profile Avatar
          GestureDetector(
            onTap: () => context.push(AppConstants.profileRoute),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFe225f4), Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF211022)
                      : const Color(0xFFf8f5f8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child:
                      authState is AuthAuthenticated &&
                          authState.user.avatarUrl != null
                      ? Image.network(
                          authState.user.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Color(0xFFe225f4),
                              size: 20,
                            );
                          },
                        )
                      : const Icon(
                          Icons.person,
                          color: Color(0xFFe225f4),
                          size: 20,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteamConnectionStatus() {
    final steamState = ref.watch(steamConnectionProvider);
    final steamNotifier = ref.read(steamConnectionProvider.notifier);

    if (steamState.status == SteamConnectionStatus.success) {
      // Exibir informações do usuário Steam conectado
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF171a21),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.videogame_asset,
                color: Color(0xFF66c0f4),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Steam conectado',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                  if (steamState.userData != null)
                    Text(
                      steamState.userData!.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                      ),
                    ),
                ],
              ),
            ),
            if (steamState.userData?.avatar != null)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(steamState.userData!.avatar),
              ),
          ],
        ),
      );
    } else if (steamState.status == SteamConnectionStatus.idle) {
      // Mostrar opção para conectar Steam
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF171a21),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.videogame_asset,
                color: Color(0xFF66c0f4),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conecte sua Steam',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Para sincronizar seus jogos',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => steamNotifier.connectSteam(),
              child: const Text(
                'Conectar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    } else if (steamState.isLoading) {
      // Mostrar loading da conexão Steam
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conectando Steam...',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Aguarde o processo no navegador',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => steamNotifier.disconnect(),
              child: const Text('Cancelar', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
    } else if (steamState.status == SteamConnectionStatus.error) {
      // Mostrar erro da conexão Steam
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Erro na conexão Steam',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  Text(
                    steamState.error ?? 'Erro desconhecido',
                    style: TextStyle(fontSize: 12, color: Colors.red.shade600),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => steamNotifier.retry(),
              child: Text(
                'Tentar Novamente',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Unable to load your games',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _loadConnectedPlatformGames(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFe225f4),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
