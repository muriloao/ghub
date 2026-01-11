import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/steam_integration_service.dart';
import '../providers/platform_auth_providers.dart';

class SteamCallbackPage extends ConsumerStatefulWidget {
  final Map<String, String> queryParameters;

  const SteamCallbackPage({super.key, required this.queryParameters});

  @override
  ConsumerState<SteamCallbackPage> createState() => _SteamCallbackPageState();
}

class _SteamCallbackPageState extends ConsumerState<SteamCallbackPage> {
  String? _errorMessage;
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  Future<void> _processCallback() async {
    try {
      debugPrint(
        'Processing Steam callback with params: ${widget.queryParameters}',
      );

      // Validar se há parâmetros necessários
      if (widget.queryParameters.isEmpty) {
        throw Exception('Nenhum parâmetro recebido da Steam');
      }

      // Extrair Steam ID do parâmetro openid.identity
      final identity = widget.queryParameters['openid.identity'];
      if (identity == null) {
        throw Exception('Parâmetro openid.identity não encontrado');
      }

      final steamIdMatch = RegExp(r'\/id\/(\d+)$').firstMatch(identity);
      if (steamIdMatch == null) {
        throw Exception(
          'Steam ID não encontrado no parâmetro identity: $identity',
        );
      }

      final steamId = steamIdMatch.group(1)!;
      debugPrint('Extracted Steam ID: $steamId');

      // Validar nonce se presente
      final nonce = widget.queryParameters['nonce'];
      debugPrint('Received nonce: $nonce');

      // Obter serviço Steam e completar autenticação
      final steamService = ref.read(steamServiceProvider);
      final result = await steamService.completeSteamConnectionWithSteamId(
        steamId,
      );

      // Atualizar estado global de autenticação
      if (result != null) {
        // TODO: Atualizar o provider de autenticação de plataforma
        // ref.read(platformAuthProvider.notifier).handleAuthSuccess('Steam', result);

        debugPrint(
          'Steam authentication successful for user: ${result.userModel.name}',
        );

        if (mounted) {
          // Mostrar sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Steam conectado com sucesso! Bem-vindo, ${result.userModel.name}',
              ),
              backgroundColor: const Color(0xFF171a21),
              duration: const Duration(seconds: 3),
            ),
          );

          // Aguardar um pouco para o usuário ver o feedback
          await Future.delayed(const Duration(seconds: 1));

          // Redirecionar para tela de integrações
          if (mounted) {
            context.go('/integrations');
          }
        }
      } else {
        throw Exception('Falha ao completar autenticação Steam');
      }
    } catch (e) {
      debugPrint('Erro no callback Steam: $e');
      setState(() {
        _errorMessage = e.toString();
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro na autenticação Steam: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );

        // Redirecionar após erro
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go('/integrations');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1b2838), // Steam dark background
      appBar: AppBar(
        title: const Text('Steam Authentication'),
        backgroundColor: const Color(0xFF171a21),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Steam logo/icon
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF171a21),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.videogame_asset,
                  color: Color(0xFF66c0f4),
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),

              if (_isProcessing && _errorMessage == null) ...[
                // Loading state
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF66c0f4)),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Processando autenticação Steam...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Aguarde enquanto validamos sua conta Steam',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Debug info (apenas em desenvolvimento)
                if (widget.queryParameters.isNotEmpty) ...[
                  ExpansionTile(
                    title: const Text(
                      'Parâmetros Recebidos (Debug)',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    iconColor: Colors.white70,
                    collapsedIconColor: Colors.white70,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.queryParameters.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '${entry.key}: ${entry.value}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],

              if (_errorMessage != null) ...[
                // Error state
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Erro na Autenticação',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Botão para tentar novamente ou voltar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => context.go('/integrations'),
                      child: const Text(
                        'Voltar',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isProcessing = true;
                        });
                        _processCallback();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66c0f4),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
