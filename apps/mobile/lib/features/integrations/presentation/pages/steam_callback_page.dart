import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import '../../data/services/steam_integration_service.dart';
import '../../../../core/services/platform_connections_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class SteamCallbackPage extends ConsumerStatefulWidget {
  final Map<String, String> queryParameters;

  const SteamCallbackPage({super.key, required this.queryParameters});

  @override
  ConsumerState<SteamCallbackPage> createState() => _SteamCallbackPageState();
}

class _SteamCallbackPageState extends ConsumerState<SteamCallbackPage> {
  bool _isProcessing = true;
  String? _errorMessage;
  String _statusMessage = 'Processando autenticação Steam...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processSteamCallback();
    });
  }

  Future<void> _processSteamCallback() async {
    try {
      setState(() {
        _statusMessage = 'Validando dados Steam...';
      });

      // Extrair Steam ID dos parâmetros de callback
      final steamId = _extractSteamId(widget.queryParameters);

      if (steamId == null) {
        throw Exception('Steam ID não encontrado no callback');
      }

      setState(() {
        _statusMessage = 'Obtendo dados do usuário Steam...';
      });

      // Usar o serviço Steam para completar a autenticação
      final dio = Dio();
      final steamService = SteamIntegrationService(dio);
      final authResult = await steamService.completeSteamConnectionWithSteamId(
        steamId,
      );

      setState(() {
        _statusMessage = 'Salvando dados da conexão...';
      });

      // Criar dados de conexão para salvar localmente
      final connectionData = PlatformConnectionData(
        platformId: 'steam',
        platformName: 'Steam',
        username: authResult.userModel.name,
        userId: steamId,
        tokens: {
          'access_token': authResult.accessToken,
          'refresh_token': authResult.refreshToken,
        },
        connectedAt: DateTime.now(),
        metadata: {
          'steamId': steamId,
          'email': authResult.userModel.email,
          'avatarUrl': authResult.userModel.avatarUrl,
        },
      );

      // Salvar conexão usando o novo serviço
      await PlatformConnectionsService.saveConnection(connectionData);

      setState(() {
        _statusMessage = 'Steam conectado com sucesso!';
        _isProcessing = false;
      });

      // Aguardar um pouco para mostrar sucesso e navegar de volta
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        context.go(AppConstants.integrationsRoute);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Erro ao conectar Steam: $e';
        _statusMessage = 'Falha na conexão';
      });
    }
  }

  String? _extractSteamId(Map<String, String> queryParameters) {
    // Steam OpenID retorna o identity na forma:
    // https://steamcommunity.com/openid/id/[STEAM_ID]
    final identity = queryParameters['openid.identity'];
    if (identity != null) {
      final steamIdMatch = RegExp(r'\/id\/(\d+)$').firstMatch(identity);
      if (steamIdMatch != null) {
        return steamIdMatch.group(1);
      }
    }

    // Fallback: verificar se Steam ID foi passado diretamente
    return queryParameters['steamId'];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Steam Connection'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _isProcessing
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.go(AppConstants.integrationsRoute),
              ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Steam Logo/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF171a21),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF171a21).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_esports,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              // Status Message
              Text(
                _statusMessage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Loading or Error
              if (_isProcessing) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFF171a21)),
                ),
              ] else if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade700,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppConstants.integrationsRoute),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Voltar para Integrações'),
                  ),
                ),
              ] else ...[
                // Success
                const SizedBox(height: 16),
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Redirecionando...',
                  style: TextStyle(color: Colors.green.shade700, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
