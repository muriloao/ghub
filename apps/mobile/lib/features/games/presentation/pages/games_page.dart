import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../widgets/game_filters.dart';
import '../widgets/games_search_bar.dart';
import '../widgets/games_view_controls.dart';
import '../widgets/games_grid.dart';
import '../providers/games_providers.dart';

class GamesPage extends ConsumerStatefulWidget {
  const GamesPage({super.key});

  @override
  ConsumerState<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends ConsumerState<GamesPage> {
  String? _steamId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserGames();
    });
  }

  void _loadUserGames() {
    final authState = ref.read(authNotifierProvider);
    if (authState is AuthAuthenticated && authState.user.id != null) {
      // Extrair Steam ID do user ID (formato: steam_76561198000000000)
      final userId = authState.user.id;
      if (userId.startsWith('steam_')) {
        _steamId = userId.substring(6); // Remove 'steam_' prefix
        ref.read(gamesNotifierProvider.notifier).loadGames(_steamId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final hasError = ref.watch(hasGamesErrorProvider);
    final errorMessage = ref.watch(gamesErrorMessageProvider);

    if (_steamId == null) {
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
              child: GamesSearchBar(steamId: _steamId!),
            ),
            const SizedBox(height: 16),

            // Filters & Controls
            Column(
              children: [
                // Horizontal Filter Chips
                GameFilters(steamId: _steamId!),
                const SizedBox(height: 16),

                // View Toggle & Count
                const GamesViewControls(),
              ],
            ),
            const SizedBox(height: 8),

            // Game Grid
            Expanded(
              child: hasError
                  ? _buildErrorState(errorMessage)
                  : GamesGrid(steamId: _steamId!),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic authState) {
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
                  const Text(
                    'Unified Library',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          // Profile Avatar
          Container(
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
                child: authState.user?.avatarUrl != null
                    ? Image.network(
                        authState.user!.avatarUrl!,
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
              onPressed: () => _loadUserGames(),
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

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF211022).withOpacity(0.9)
            : const Color(0xFFf8f5f8).withOpacity(0.9),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, 'Home', true),
              _buildNavItem(Icons.search, 'Browse', false),

              // Add Button (Floating)
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFe225f4),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFe225f4).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),

              _buildNavItem(Icons.bar_chart, 'Stats', false),
              _buildNavItem(Icons.settings, 'Settings', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        // Handle navigation
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isActive ? const Color(0xFFe225f4) : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFFe225f4) : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
