import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/integrations_cache_service.dart';
import '../../data/services/xbox_live_service.dart';
import '../providers/integrations_providers.dart';

/// Página de callback para processar resposta da autenticação Xbox
class XboxCallbackPage extends ConsumerStatefulWidget {
  final String? code;
  final String? state;
  final String? error;

  const XboxCallbackPage({super.key, this.code, this.state, this.error});

  @override
  ConsumerState<XboxCallbackPage> createState() => _XboxCallbackPageState();
}

class _XboxCallbackPageState extends ConsumerState<XboxCallbackPage> {
  bool _isProcessing = true;
  String? _error;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processXboxCallback();
    });
  }

  Future<void> _processXboxCallback() async {
    try {
      // Verificar se houve erro na autenticação
      if (widget.error != null) {
        setState(() {
          _error = 'Autenticação Xbox cancelada ou falhou: ${widget.error}';
          _isProcessing = false;
        });
        return;
      }

      // Verificar se o código foi recebido
      if (widget.code == null || widget.code!.isEmpty) {
        setState(() {
          _error = 'Código de autenticação Xbox não recebido';
          _isProcessing = false;
        });
        return;
      }

      if (!mounted) return;

      // Completar autenticação com Xbox Live
      final xboxService = XboxLiveService(Dio());
      final xboxUser = await xboxService.completeAuthenticationWithCode(
        widget.code!,
      );

      if (!mounted) return;

      // Salvar dados no cache local
      await IntegrationsCacheService.cacheXboxConnection(
        xboxUser,
        'temp_access_token', // Em produção, salvaria o token real
      );

      // Buscar e cachear jogos do usuário
      try {
        final games = await xboxService.fetchUserGames(xboxUser.xuid);
        await IntegrationsCacheService.cacheXboxGames(games);
      } catch (e) {
        // Log do erro mas não falha a conexão
        debugPrint('Erro ao buscar jogos Xbox: $e');
      }

      // Atualizar estado das integrações
      await ref.read(integrationsNotifierProvider.notifier).refreshPlatforms();

      setState(() {
        _successMessage = 'Xbox conectado com sucesso!';
        _isProcessing = false;
      });

      if (mounted) {
        // Aguardar um pouco para mostrar mensagem de sucesso
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          // Navegar de volta para integrações
          context.pushReplacement(AppConstants.integrationsRoute);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erro na autenticação Xbox: $e';
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF211022)
          : const Color(0xFFf8f5f8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Xbox Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF107C10),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF107C10).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'X',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Xbox Live',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // Status
              if (_isProcessing) ...[
                const SizedBox(height: 32),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF107C10)),
                ),
                const SizedBox(height: 24),
                Text(
                  'Conectando com Xbox Live...',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else if (_error != null) ...[
                const SizedBox(height: 32),
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 24),
                Text(
                  'Erro na Conexão',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () =>
                      context.pushReplacement(AppConstants.integrationsRoute),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF107C10),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Voltar para Integrações'),
                ),
              ] else if (_successMessage != null) ...[
                const SizedBox(height: 32),
                Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green.shade400,
                ),
                const SizedBox(height: 24),
                Text(
                  'Sucesso!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _successMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 48),

              // Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF107C10),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Conectando sua conta Xbox para sincronizar jogos e conquistas',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
