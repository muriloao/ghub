import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghub_mobile/features/games/presentation/states/games_state.dart';
import '../../domain/entities/game.dart';
import '../providers/favorites_providers.dart';
import '../providers/games_providers.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  final Game game;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteButton({
    super.key,
    required this.game,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Animação de toque
    await _animationController.forward();
    await _animationController.reverse();

    final success = await ref
        .read(favoritesNotifierProvider.notifier)
        .toggleFavorite(widget.game.id);

    if (success) {
      // Atualiza filtros se estiver no filtro de favoritos
      final currentFilter = ref.read(currentGameFilterProvider);
      if (currentFilter == GameFilter.favorites) {
        await ref.read(gamesNotifierProvider.notifier).refreshFilters();
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isGameFavoriteProvider(widget.game.id));

    return GestureDetector(
      onTap: _toggleFavorite,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size + 8,
              height: widget.size + 8,
              decoration: BoxDecoration(
                color: isFavorite
                    ? Colors.red.withValues(alpha: 0.9)
                    : Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular((widget.size + 8) / 2),
                border: Border.all(
                  color: isFavorite
                      ? Colors.red
                      : Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isFavorite
                        ? Colors.red.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _isProcessing
                  ? Center(
                      child: SizedBox(
                        width: widget.size * 0.6,
                        height: widget.size * 0.6,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.activeColor ?? Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: widget.size,
                      color: isFavorite
                          ? (widget.activeColor ?? Colors.white)
                          : (widget.inactiveColor ??
                                Colors.white.withValues(alpha: 0.8)),
                    ),
            ),
          );
        },
      ),
    );
  }
}

/// Widget de favorito simplificado para listas
class SimpleFavoriteButton extends ConsumerWidget {
  final Game game;
  final double size;

  const SimpleFavoriteButton({super.key, required this.game, this.size = 20});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isGameFavoriteProvider(game.id));

    return GestureDetector(
      onTap: () async {
        await ref
            .read(favoritesNotifierProvider.notifier)
            .toggleFavorite(game.id);

        // Atualiza filtros se necessário
        final currentFilter = ref.read(currentGameFilterProvider);
        if (currentFilter == GameFilter.favorites) {
          await ref.read(gamesNotifierProvider.notifier).refreshFilters();
        }
      },
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        size: size,
        color: isFavorite ? Colors.red : Colors.grey.shade400,
      ),
    );
  }
}
