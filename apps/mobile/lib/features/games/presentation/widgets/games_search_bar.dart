import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/games_providers.dart';

class GamesSearchBar extends ConsumerStatefulWidget {
  final String steamId;

  const GamesSearchBar({super.key, required this.steamId});

  @override
  ConsumerState<GamesSearchBar> createState() => _GamesSearchBarState();
}

class _GamesSearchBarState extends ConsumerState<GamesSearchBar> {
  late TextEditingController _controller;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2d1b2e)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: (query) {
          // Debounce search to avoid too many API calls
          _debounceSearch(query);
        },
        decoration: InputDecoration(
          hintText: 'Search games, platforms...',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
          suffixIcon: _buildSuffixIcon(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (_controller.text.isNotEmpty) {
      return IconButton(
        icon: Icon(Icons.clear, color: Colors.grey.shade400),
        onPressed: () {
          _controller.clear();
          ref.read(gamesNotifierProvider.notifier).clearSearch();
        },
      );
    }

    return GestureDetector(
      onTap: () {
        // Voice search functionality could be implemented here
        _toggleVoiceSearch();
      },
      child: Icon(
        _isListening ? Icons.mic : Icons.mic_none,
        color: _isListening ? const Color(0xFFe225f4) : Colors.grey.shade500,
        size: 20,
      ),
    );
  }

  void _debounceSearch(String query) {
    // Simple debounce implementation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_controller.text == query && query.trim().isNotEmpty) {
        ref.read(gamesNotifierProvider.notifier).setSearchQuery(query);
      } else if (query.trim().isEmpty) {
        ref.read(gamesNotifierProvider.notifier).clearSearch();
      }
    });
  }

  void _toggleVoiceSearch() {
    setState(() {
      _isListening = !_isListening;
    });

    // Simulate voice search animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    });
  }
}
