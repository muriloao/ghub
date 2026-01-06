import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/services/deep_link_service.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_notifier.dart';

/// Página que processa o callback da autenticação Epic Games
class EpicCallbackPage extends ConsumerStatefulWidget {
  final Map<String, String> queryParams;

  const EpicCallbackPage({super.key, required this.queryParams});

  @override
  ConsumerState<EpicCallbackPage> createState() => _EpicCallbackPageState();
}

class _EpicCallbackPageState extends ConsumerState<EpicCallbackPage> {
  bool _isProcessing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processEpicCallback();
  }

  Future<void> _processEpicCallback() async {
    try {
      // Aguardar um pouco para garantir que os providers estejam prontos
      await Future.delayed(const Duration(milliseconds: 200));

      // Extrair código de autorização e state do callback
      final code = widget.queryParams['code'];
      final state = widget.queryParams['state'];
      final error = widget.queryParams['error'];

      if (error != null) {
        setState(() {
          _error = 'Erro na autenticação Epic Games: $error';
          _isProcessing = false;
        });
        return;
      }

      if (code == null) {
        setState(() {
          _error = 'Código de autorização não encontrado no callback';
          _isProcessing = false;
        });
        return;
      }

      if (state == null) {
        setState(() {
          _error = 'State não encontrado no callback';
          _isProcessing = false;
        });
        return;
      }

      if (!mounted) return;

      await _authenticateWithCode(code, state);
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _error = 'Erro ao processar callback: $e';
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _authenticateWithCode(String code, String state) async {
    try {
      // Verificar se o widget ainda está montado antes de acessar providers
      if (!mounted) return;

      final epicAuthService = ref.read(epicAuthServiceProvider);

      // Completar autenticação usando o código extraído
      final authResult = await epicAuthService.completeAuthenticationWithCode(
        code,
        state,
      );

      // Verificar novamente se está montado antes de continuar
      if (!mounted) return;

      // Salvar resultado da autenticação
      final authNotifier = ref.read(authNotifierProvider.notifier);
      // await authNotifier.loginWithAuthResult(
      //   authResult,
      //   epicUserId: authResult.user.id,
      // );

      if (mounted) {
        // Navegar para home após autenticação bem-sucedida
        context.pushReplacement(AppConstants.homeRoute);
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _error = 'Erro na autenticação Epic Games: $e';
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
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFe225f4)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Processando autenticação Epic Games...',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ] else if (_error != null) ...[
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 24),
              Text(
                'Erro na Autenticação',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.pushReplacement('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFe225f4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Voltar ao Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
