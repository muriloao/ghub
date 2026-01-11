import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/steam_connection_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          // Outras seções de configurações
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificações'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),

          // Seção Steam
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Integrações',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _buildSteamSection(ref),

          const Divider(),
          // Outras opções
          const ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacidade'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildSteamSection(WidgetRef ref) {
    final steamState = ref.watch(steamConnectionProvider);
    final steamNotifier = ref.read(steamConnectionProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF171a21),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.videogame_asset,
                color: Color(0xFF66c0f4),
                size: 20,
              ),
            ),
            title: const Text('Steam'),
            subtitle: Text(_getStatusDescription(steamState.status)),
            trailing: _buildTrailingWidget(steamState, steamNotifier),
          ),

          // Informações do usuário se conectado
          if (steamState.status == SteamConnectionStatus.success &&
              steamState.userData != null) ...[
            const Divider(height: 1),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(steamState.userData!.avatar),
                radius: 16,
              ),
              title: Text(steamState.userData!.name),
              subtitle: Text('Steam ID: ${steamState.steamId}'),
              dense: true,
            ),
          ],

          // Erro se houver
          if (steamState.status == SteamConnectionStatus.error) ...[
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      steamState.error ?? 'Erro desconhecido',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrailingWidget(
    SteamConnectionState state,
    SteamConnectionNotifier notifier,
  ) {
    switch (state.status) {
      case SteamConnectionStatus.idle:
        return TextButton(
          onPressed: () => notifier.connectSteam(),
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
            TextButton(
              onPressed: () => notifier.disconnect(),
              child: const Text('Desconectar'),
            ),
          ],
        );

      case SteamConnectionStatus.error:
        return TextButton(
          onPressed: () => notifier.retry(),
          child: const Text('Tentar Novamente'),
        );
    }
  }

  String _getStatusDescription(SteamConnectionStatus status) {
    switch (status) {
      case SteamConnectionStatus.idle:
        return 'Não conectada';
      case SteamConnectionStatus.connecting:
        return 'Abrindo navegador...';
      case SteamConnectionStatus.polling:
        return 'Aguardando confirmação...';
      case SteamConnectionStatus.success:
        return 'Conectada com sucesso';
      case SteamConnectionStatus.error:
        return 'Erro na conexão';
    }
  }
}
