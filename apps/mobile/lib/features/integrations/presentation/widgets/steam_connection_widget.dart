import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/steam_connection_provider.dart';

class SteamConnectionWidget extends ConsumerWidget {
  const SteamConnectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final steamState = ref.watch(steamConnectionProvider);
      final steamNotifier = ref.read(steamConnectionProvider.notifier);

      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com ícone Steam
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF171a21),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.videogame_asset,
                      color: Color(0xFF66c0f4),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Steam',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getStatusText(steamState.status),
                          style: TextStyle(
                            fontSize: 14,
                            color: _getStatusColor(steamState.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildActionButton(context, ref, steamState, steamNotifier),
                ],
              ),

              // Conteúdo específico por status
              const SizedBox(height: 16),
              _buildStatusContent(steamState),
            ],
          ),
        ),
      );
    } catch (e) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Steam connection widget error'),
              Text(
                e.toString(),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    SteamConnectionState state,
    SteamConnectionNotifier notifier,
  ) {
    switch (state.status) {
      case SteamConnectionStatus.idle:
        return ElevatedButton(
          onPressed: () => notifier.connectSteam(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF66c0f4),
            foregroundColor: Colors.white,
          ),
          child: const Text('Conectar'),
        );

      case SteamConnectionStatus.connecting:
      case SteamConnectionStatus.polling:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => notifier.disconnect(),
              child: const Text('Cancelar'),
            ),
          ],
        );

      case SteamConnectionStatus.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => notifier.disconnect(),
              child: const Text('Desconectar'),
            ),
          ],
        );

      case SteamConnectionStatus.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => notifier.retry(),
              child: const Text('Tentar Novamente'),
            ),
            TextButton(
              onPressed: () => notifier.disconnect(),
              child: const Text('Cancelar'),
            ),
          ],
        );
    }
  }

  Widget _buildStatusContent(SteamConnectionState state) {
    switch (state.status) {
      case SteamConnectionStatus.idle:
        return const Text(
          'Conecte sua conta Steam para sincronizar seus jogos e conquistas.',
          style: TextStyle(color: Colors.grey),
        );

      case SteamConnectionStatus.connecting:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Abrindo Steam no navegador...',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              'Complete o login na Steam e aguarde.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        );

      case SteamConnectionStatus.polling:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aguardando confirmação da Steam...',
              style: TextStyle(color: Colors.orange),
            ),
            const SizedBox(height: 8),
            Text(
              'Sessão: ${state.sessionId?.substring(0, 8)}...',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(),
          ],
        );

      case SteamConnectionStatus.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (state.userData?.avatar != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(state.userData!.avatar),
                    radius: 16,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userData?.name ?? 'Usuário Steam',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Steam ID: ${state.steamId}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

      case SteamConnectionStatus.error:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border.all(color: Colors.red.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Erro na Conexão',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                state.error ?? 'Erro desconhecido',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        );
    }
  }

  String _getStatusText(SteamConnectionStatus status) {
    switch (status) {
      case SteamConnectionStatus.idle:
        return 'Desconectada';
      case SteamConnectionStatus.connecting:
        return 'Conectando...';
      case SteamConnectionStatus.polling:
        return 'Aguardando...';
      case SteamConnectionStatus.success:
        return 'Conectada';
      case SteamConnectionStatus.error:
        return 'Erro';
    }
  }

  Color _getStatusColor(SteamConnectionStatus status) {
    switch (status) {
      case SteamConnectionStatus.idle:
        return Colors.grey;
      case SteamConnectionStatus.connecting:
      case SteamConnectionStatus.polling:
        return Colors.orange;
      case SteamConnectionStatus.success:
        return Colors.green;
      case SteamConnectionStatus.error:
        return Colors.red;
    }
  }
}
