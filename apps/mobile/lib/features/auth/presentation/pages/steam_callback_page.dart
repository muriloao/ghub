import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/services/deep_link_service.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_notifier.dart';

/// Página que processa o callback da autenticação Steam
class SteamCallbackPage extends ConsumerStatefulWidget {
  final Map<String, String> queryParams;

  const SteamCallbackPage({super.key, required this.queryParams});

  @override
  ConsumerState<SteamCallbackPage> createState() => _SteamCallbackPageState();
}

class _SteamCallbackPageState extends ConsumerState<SteamCallbackPage> {
  bool _isProcessing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processSteamCallback();
  }

  Future<void> _processSteamCallback() async {
    try {
      // Aguardar um pouco para garantir que os providers estejam prontos
      await Future.delayed(const Duration(milliseconds: 200));

      // Extrair Steam ID do callback
      final deepLinkService = DeepLinkService();
      final steamId = deepLinkService.extractSteamIdFromCallbackQueryParameters(
        widget.queryParams,
      );

      if (steamId != null) {
        // Processar autenticação com Steam ID
        await _authenticateWithSteamId(steamId);
      } else {
        setState(() {
          _error = 'Steam ID não encontrado no callback';
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao processar callback: $e';
        _isProcessing = false;
      });
    }
  }

  Future<void> _authenticateWithSteamId(String steamId) async {
    try {
      // Verificar se o widget ainda está montado antes de acessar providers
      if (!mounted) return;

      final steamAuthService = ref.read(steamAuthServiceProvider);

      // Completar autenticação usando o Steam ID extraído
      final authResult = await steamAuthService
          .completeAuthenticationWithSteamId(steamId);

      // Verificar novamente se está montado antes de continuar
      if (!mounted) return;

      // Salvar resultado da autenticação
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.loginWithAuthResult(authResult);

      if (mounted) {
        // Navegar para home após autenticação bem-sucedida
        context.pushReplacement(AppConstants.homeRoute);
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _error = 'Erro na autenticação: $e';
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0e27),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isProcessing) ...[
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF66c0f4)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Processando autenticação Steam...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Aguarde enquanto validamos seus dados',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ] else if (_error != null) ...[
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 24),
              const Text(
                'Erro na Autenticação',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66c0f4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  context.pushReplacement(AppConstants.loginRoute);
                },
                child: const Text('Tentar Novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
