import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghub_mobile/core/auth/platform_manager.dart';
import '../providers/platform_auth_providers.dart';

/// Tela de exemplo mostrando como usar as integrações unificadas
class PlatformIntegrationsScreen extends ConsumerWidget {
  const PlatformIntegrationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfos = ref.watch(platformInfosProvider);
    final authState = ref.watch(platformAuthProvider);
    final configuredPlatforms = ref.watch(configuredPlatformsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrações de Plataforma'),
        actions: [
          if (authState.hasAuthenticatedPlatforms)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showDisconnectAllDialog(context, ref),
              tooltip: 'Desconectar de todas',
            ),
        ],
      ),
      body: Column(
        children: [
          // Status geral
          _buildStatusCard(authState),

          // Lista de plataformas
          Expanded(
            child: ListView.builder(
              itemCount: platformInfos.length,
              itemBuilder: (context, index) {
                final platform = platformInfos[index];
                final isAuthenticated = authState.authenticatedPlatformNames
                    .contains(platform.name);

                return _buildPlatformCard(
                  context,
                  ref,
                  platform,
                  isAuthenticated,
                  authState.isLoading &&
                      authState.currentPlatform == platform.name,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(PlatformAuthState authState) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status das Integrações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Plataformas conectadas: ${authState.authenticatedPlatformCount}',
              style: TextStyle(fontSize: 16),
            ),
            if (authState.authenticatedPlatformNames.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Conectadas: ${authState.authenticatedPlatformNames.join(', ')}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
            if (authState.error != null) ...[
              const SizedBox(height: 8),
              Text(
                'Erro: ${authState.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformCard(
    BuildContext context,
    WidgetRef ref,
    PlatformInfo platform,
    bool isAuthenticated,
    bool isLoading,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(platform.color),
          child: Icon(
            _getPlatformIcon(platform.name),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(platform.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              platform.isConfigured
                  ? (isAuthenticated ? 'Conectado' : 'Pronto para conectar')
                  : 'Não configurado',
            ),
            if (!platform.isConfigured)
              Text(
                'Configure as credenciais no .env',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : _buildActionButton(context, ref, platform, isAuthenticated),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    PlatformInfo platform,
    bool isAuthenticated,
  ) {
    if (!platform.isConfigured) {
      return Icon(Icons.settings, color: Colors.grey);
    }

    if (isAuthenticated) {
      return IconButton(
        icon: const Icon(Icons.logout, color: Colors.red),
        onPressed: () => _disconnectFromPlatform(ref, platform.name),
        tooltip: 'Desconectar',
      );
    }

    return ElevatedButton(
      onPressed: () => _connectToPlatform(context, ref, platform.name),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(platform.color),
        foregroundColor: Colors.white,
      ),
      child: const Text('Conectar'),
    );
  }

  IconData _getPlatformIcon(String platformName) {
    switch (platformName.toLowerCase()) {
      case 'steam':
        return Icons.videogame_asset;
      default:
        return Icons.gamepad;
    }
  }

  void _connectToPlatform(
    BuildContext context,
    WidgetRef ref,
    String platformName,
  ) {
    ref
        .read(platformAuthProvider.notifier)
        .authenticateWithPlatform(platformName, context);
  }

  void _disconnectFromPlatform(WidgetRef ref, String platformName) {
    ref
        .read(platformAuthProvider.notifier)
        .disconnectFromPlatform(platformName);
  }

  void _showDisconnectAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desconectar de Todas'),
        content: const Text(
          'Tem certeza de que deseja desconectar de todas as plataformas?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(platformAuthProvider.notifier)
                  .disconnectFromAllPlatforms();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Desconectar Todas'),
          ),
        ],
      ),
    );
  }
}
