import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../integrations/presentation/providers/integrations_providers.dart';
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
      _loadConnectedPlatformGames();
    });
  }

  void _loadConnectedPlatformGames() async {
    final connectedPlatforms =
        await PlatformConnectionsService.getConnections();

    // Carregar jogos de cada plataforma conectada
    for (final platformConnection in connectedPlatforms) {
      switch (platformConnection.platformId) {
        case 'steam':
          _loadSteamGames(platformConnection);
          break;
        case 'xbox':
          _loadXboxGames(platformConnection);
          break;
        case 'epic_games':
          _loadEpicGames(platformConnection);
          break;
      }
    }
  }

  void _loadSteamGames(PlatformConnectionData platformConnection) {
    // Extrair Steam ID dos dados da plataforma conectada
    final steamId =
        platformConnection.metadata['steamId'] ?? platformConnection.userId;
    if (steamId != null) {
      ref.read(gamesNotifierProvider.notifier).loadGames(steamId);
    }
  }

  void _loadXboxGames(PlatformConnectionData platformConnection) {
    // Implementar carregamento de jogos Xbox
    // TODO: Implementar quando Xbox games service estiver pronto
  }

  void _loadEpicGames(PlatformConnectionData platformConnection) {
    // Implementar carregamento de jogos Epic
    // TODO: Implementar quando Epic games service estiver pronto
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

    if (gamesState.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF211022)
            : const Color(0xFFf8f5f8),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFe225f4)),
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
            ? const Color(0xFF211022).withOpacity(0.95)
            : const Color(0xFFf8f5f8).withOpacity(0.95),
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
                  color: const Color(0xFFe225f4).withOpacity(0.2),
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
