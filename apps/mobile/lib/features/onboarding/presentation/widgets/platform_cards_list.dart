import 'package:flutter/material.dart';
import '../../domain/entities/gaming_platform.dart';
import 'platform_card.dart';

class PlatformCardsList extends StatelessWidget {
  final List<GamingPlatform> platforms;
  final Function(String) onConnect;
  final Function(String) onManage;

  const PlatformCardsList({
    super.key,
    required this.platforms,
    required this.onConnect,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: platforms.map((platform) {
        return PlatformCard(
          platform: platform,
          onConnect: () => onConnect(platform.type.name.toLowerCase()),
          onManage: () => onManage(platform.type.name.toLowerCase()),
        );
      }).toList(),
    );
  }
}
