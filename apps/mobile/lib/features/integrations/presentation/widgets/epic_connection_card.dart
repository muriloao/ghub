import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/epic_connection_provider.dart';

class EpicConnectionCard extends ConsumerStatefulWidget {
  const EpicConnectionCard({super.key});

  @override
  ConsumerState<EpicConnectionCard> createState() => _EpicConnectionCardState();
}

class _EpicConnectionCardState extends ConsumerState<EpicConnectionCard> {
  @override
  void initState() {
    super.initState();

    // Auto-restaurar conexão se houver dados salvos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(epicAutoRestoreProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      final epicState = ref.watch(epicConnectionProvider);
      final epicNotifier = ref.read(epicConnectionProvider.notifier);

      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com ícone Epic Games
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0078f3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.videogame_asset,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Epic Games',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getStatusText(epicState.status),
                          style: TextStyle(
                            fontSize: 14,
                            color: _getStatusColor(epicState.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: _buildActionButton(
                      context,
                      ref,
                      epicState,
                      epicNotifier,
                    ),
                  ),
                ],
              ),

              // Conteúdo específico por status
              const SizedBox(height: 16),
              _buildStatusContent(epicState),
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
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text('Epic Games connection widget error'),
              Text(
                e.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
    EpicConnectionState state,
    EpicConnectionNotifier notifier,
  ) {
    switch (state.status) {
      case EpicConnectionStatus.idle:
        return ElevatedButton(
          onPressed: () => notifier.connectEpic(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0078f3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Conectar'),
        );

      case EpicConnectionStatus.connecting:
      case EpicConnectionStatus.polling:
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0078f3)),
            ),
          ),
        );

      case EpicConnectionStatus.success:
        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'disconnect':
                notifier.disconnect();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'disconnect',
              child: Text('Desconectar'),
            ),
          ],
        );

      case EpicConnectionStatus.error:
        return ElevatedButton(
          onPressed: () => notifier.retry(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Tentar novamente'),
        );
    }
  }

  Widget _buildStatusContent(EpicConnectionState state) {
    switch (state.status) {
      case EpicConnectionStatus.idle:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Conecte sua conta Epic Games para sincronizar sua biblioteca e conquistas.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );

      case EpicConnectionStatus.connecting:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
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
                child: Text(
                  'Iniciando conexão com Epic Games...',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );

      case EpicConnectionStatus.polling:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Aguardando autorização...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Complete o processo de login no navegador que foi aberto.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        );

      case EpicConnectionStatus.success:
        if (state.userData != null) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Conectado como ${state.userData!.displayName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        state.userData!.email,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                if (state.userData!.locale.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.language_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Idioma: ${state.userData!.locale.toUpperCase()}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }
        return const SizedBox.shrink();

      case EpicConnectionStatus.error:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[600], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Erro na conexão',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (state.error != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.error!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }

  String _getStatusText(EpicConnectionStatus status) {
    switch (status) {
      case EpicConnectionStatus.idle:
        return 'Desconectado';
      case EpicConnectionStatus.connecting:
        return 'Conectando...';
      case EpicConnectionStatus.polling:
        return 'Aguardando autorização...';
      case EpicConnectionStatus.success:
        return 'Conectado';
      case EpicConnectionStatus.error:
        return 'Erro na conexão';
    }
  }

  Color _getStatusColor(EpicConnectionStatus status) {
    switch (status) {
      case EpicConnectionStatus.idle:
        return Colors.grey;
      case EpicConnectionStatus.connecting:
      case EpicConnectionStatus.polling:
        return Colors.orange;
      case EpicConnectionStatus.success:
        return Colors.green;
      case EpicConnectionStatus.error:
        return Colors.red;
    }
  }
}

// Widget simples para status Epic Games (para usar em outras telas)
class EpicStatusIndicator extends ConsumerWidget {
  final bool showLabel;

  const EpicStatusIndicator({super.key, this.showLabel = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(isEpicConnectedProvider);
    final isLoading = ref.watch(isEpicLoadingProvider);
    final userData = ref.watch(epicUserDataProvider);

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF0078f3),
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 8),
            const Text('Conectando...'),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isConnected ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: isConnected ? Colors.green : Colors.grey,
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            isConnected
                ? (userData?.displayName ?? 'Epic Games')
                : 'Desconectado',
            style: TextStyle(
              color: isConnected ? Colors.green : Colors.grey,
              fontWeight: isConnected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }
}
