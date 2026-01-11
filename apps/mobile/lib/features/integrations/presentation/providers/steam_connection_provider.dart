import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ghub_mobile/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';

// Estados da conexão Steam
enum SteamConnectionStatus { idle, connecting, polling, success, error }

class SteamConnectionState {
  final SteamConnectionStatus status;
  final String? sessionId;
  final String? steamId;
  final SteamUserData? userData;
  final String? error;

  const SteamConnectionState({
    required this.status,
    this.sessionId,
    this.steamId,
    this.userData,
    this.error,
  });

  SteamConnectionState copyWith({
    SteamConnectionStatus? status,
    String? sessionId,
    String? steamId,
    SteamUserData? userData,
    String? error,
  }) {
    return SteamConnectionState(
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      steamId: steamId ?? this.steamId,
      userData: userData ?? this.userData,
      error: error ?? this.error,
    );
  }

  bool get isConnected => status == SteamConnectionStatus.success;
  bool get isLoading =>
      status == SteamConnectionStatus.connecting ||
      status == SteamConnectionStatus.polling;
}

class SteamUserData {
  final String name;
  final String avatar;
  final String profileUrl;
  final String? accessToken;
  final String? refreshToken;

  const SteamUserData({
    required this.name,
    required this.avatar,
    required this.profileUrl,
    this.accessToken,
    this.refreshToken,
  });

  factory SteamUserData.fromJson(Map<String, dynamic> json) {
    return SteamUserData(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

// Notifier para gerenciar conexão Steam
class SteamConnectionNotifier extends StateNotifier<SteamConnectionState> {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  Timer? _pollingTimer;

  // Configurações - ajustar conforme seu backend
  static const Duration _pollingInterval = Duration(seconds: 2);
  static const Duration _maxPollingDuration = Duration(minutes: 10);

  // Keys para armazenamento seguro
  static const String _steamAccessTokenKey = 'steam_access_token';
  static const String _steamRefreshTokenKey = 'steam_refresh_token';
  static const String _steamUserDataKey = 'steam_user_data';
  static const String _steamIdKey = 'steam_id';

  SteamConnectionNotifier(this._dio, this._secureStorage)
    : super(const SteamConnectionState(status: SteamConnectionStatus.idle));

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  /// Inicia processo de conexão Steam
  Future<void> connectSteam() async {
    try {
      state = state.copyWith(
        status: SteamConnectionStatus.connecting,
        error: null,
      );

      // Chamar endpoint /api/auth/steam/start
      final response = await _dio.get(
        '${AppConstants.baseUrl}/auth/steam/start',
        options: Options(
          followRedirects: false, // Importante: não seguir redirect
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      // Extrair URL de redirecionamento do header Location
      final authUrl = response.headers.value('location');
      if (authUrl == null) {
        throw Exception('URL de autenticação não encontrada');
      }

      // Extrair session_id da URL (método alternativo)
      // Nota: Como fazemos redirect 302, precisamos extrair o session_id
      // de forma alternativa. Aqui está uma implementação de fallback:
      final sessionId = _extractSessionFromUrl(authUrl);
      if (sessionId == null) {
        throw Exception('Session ID não encontrado');
      }

      state = state.copyWith(
        sessionId: sessionId,
        status: SteamConnectionStatus.polling,
      );

      // Abrir navegador externo
      await _openExternalBrowser(authUrl);

      // Iniciar polling
      _startPolling();
    } catch (e) {
      state = state.copyWith(
        status: SteamConnectionStatus.error,
        error: 'Erro ao iniciar conexão Steam: $e',
      );
    }
  }

  /// Abre URL no navegador externo
  Future<void> _openExternalBrowser(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView, // Força navegador externo
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
        ),
      );
    } else {
      throw Exception('Não foi possível abrir o navegador');
    }
  }

  /// Extrai session_id da URL de auth Steam
  String? _extractSessionFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final returnTo = uri.queryParameters['openid.return_to'];
      if (returnTo != null) {
        final returnUri = Uri.parse(returnTo);
        return returnUri.queryParameters['session_id'];
      }
    } catch (e) {
      print('Erro ao extrair session ID: $e');
    }
    return null;
  }

  /// Inicia polling do status da sessão
  void _startPolling() {
    if (state.sessionId == null) return;

    final startTime = DateTime.now();

    _pollingTimer = Timer.periodic(_pollingInterval, (timer) async {
      // Verificar timeout
      if (DateTime.now().difference(startTime) > _maxPollingDuration) {
        timer.cancel();
        state = state.copyWith(
          status: SteamConnectionStatus.error,
          error: 'Timeout: Conexão não completada em 10 minutos',
        );
        return;
      }

      await _checkConnectionStatus();
    });
  }

  /// Verifica status da conexão no backend
  Future<void> _checkConnectionStatus() async {
    if (state.sessionId == null) return;

    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/auth/steam/status/${state.sessionId}',
      );

      final data = response.data;
      final status = data['status'] as String;

      switch (status) {
        case 'success':
          _pollingTimer?.cancel();

          final userData = data['userData'] != null
              ? SteamUserData.fromJson(data['userData'])
              : null;

          final steamId = data['steamId'] as String?;

          // Salvar tokens de forma segura
          if (userData != null) {
            await _saveTokensSecurely(steamId, userData);
          }

          state = state.copyWith(
            status: SteamConnectionStatus.success,
            steamId: steamId,
            userData: userData,
          );
          break;

        case 'error':
          _pollingTimer?.cancel();
          state = state.copyWith(
            status: SteamConnectionStatus.error,
            error: data['error'] ?? 'Erro desconhecido na conexão Steam',
          );
          break;

        case 'pending':
          // Continue polling
          break;

        default:
          print('Status desconhecido: $status');
      }
    } catch (e) {
      print('Erro ao verificar status: $e');
      // Não parar polling por erro temporário de rede
    }
  }

  /// Desconecta Steam (limpa estado local e tokens)
  Future<void> disconnect() async {
    _pollingTimer?.cancel();

    // Limpar tokens salvos
    await _clearSavedTokens();

    state = const SteamConnectionState(status: SteamConnectionStatus.idle);
  }

  /// Salva tokens de forma segura no FlutterSecureStorage
  Future<void> _saveTokensSecurely(
    String? steamId,
    SteamUserData userData,
  ) async {
    try {
      if (steamId != null) {
        await _secureStorage.write(key: _steamIdKey, value: steamId);
      }

      if (userData.accessToken != null) {
        await _secureStorage.write(
          key: _steamAccessTokenKey,
          value: userData.accessToken!,
        );
      }

      if (userData.refreshToken != null) {
        await _secureStorage.write(
          key: _steamRefreshTokenKey,
          value: userData.refreshToken!,
        );
      }

      // Salvar dados do usuário (sem tokens sensíveis)
      final userDataToSave = {
        'name': userData.name,
        'avatar': userData.avatar,
        'profileUrl': userData.profileUrl,
      };
      await _secureStorage.write(
        key: _steamUserDataKey,
        value: json.encode(userDataToSave),
      );

      print('✅ Tokens Steam salvos de forma segura');
    } catch (e) {
      print('❌ Erro ao salvar tokens Steam: $e');
    }
  }

  /// Limpa todos os tokens salvos
  Future<void> _clearSavedTokens() async {
    try {
      await _secureStorage.delete(key: _steamIdKey);
      await _secureStorage.delete(key: _steamAccessTokenKey);
      await _secureStorage.delete(key: _steamRefreshTokenKey);
      await _secureStorage.delete(key: _steamUserDataKey);
      print('🗑️ Tokens Steam removidos');
    } catch (e) {
      print('❌ Erro ao limpar tokens Steam: $e');
    }
  }

  /// Recupera tokens salvos (para reconexão automática)
  Future<Map<String, String?>> getSavedTokens() async {
    try {
      final steamId = await _secureStorage.read(key: _steamIdKey);
      final accessToken = await _secureStorage.read(key: _steamAccessTokenKey);
      final refreshToken = await _secureStorage.read(
        key: _steamRefreshTokenKey,
      );
      final userDataJson = await _secureStorage.read(key: _steamUserDataKey);

      return {
        'steamId': steamId,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'userData': userDataJson,
      };
    } catch (e) {
      print('❌ Erro ao recuperar tokens Steam: $e');
      return {};
    }
  }

  /// Verifica se há tokens salvos (usuário já conectou antes)
  Future<bool> hasValidSavedTokens() async {
    try {
      final tokens = await getSavedTokens();
      return tokens['steamId'] != null && tokens['accessToken'] != null;
    } catch (e) {
      return false;
    }
  }

  /// Restaura conexão usando tokens salvos
  Future<void> restoreConnection() async {
    try {
      final tokens = await getSavedTokens();

      if (tokens['steamId'] != null && tokens['userData'] != null) {
        final userDataJson = json.decode(tokens['userData']!);
        final userData = SteamUserData(
          name: userDataJson['name'] ?? '',
          avatar: userDataJson['avatar'] ?? '',
          profileUrl: userDataJson['profileUrl'] ?? '',
          accessToken: tokens['accessToken'],
          refreshToken: tokens['refreshToken'],
        );

        state = state.copyWith(
          status: SteamConnectionStatus.success,
          steamId: tokens['steamId'],
          userData: userData,
        );

        print('🔄 Conexão Steam restaurada automaticamente');
      }
    } catch (e) {
      print('❌ Erro ao restaurar conexão Steam: $e');
    }
  }

  /// Retry conexão em caso de erro
  Future<void> retry() async {
    if (state.status == SteamConnectionStatus.error) {
      await connectSteam();
    }
  }
}

// Provider principal da conexão Steam
final steamConnectionProvider =
    StateNotifierProvider<SteamConnectionNotifier, SteamConnectionState>((ref) {
      final dio = Dio();
      const secureStorage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
      return SteamConnectionNotifier(dio, secureStorage);
    });

// Providers convenientes para UI
final isSteamConnectedProvider = Provider<bool>((ref) {
  final steamState = ref.watch(steamConnectionProvider);
  return steamState.isConnected;
});

final isSteamLoadingProvider = Provider<bool>((ref) {
  final steamState = ref.watch(steamConnectionProvider);
  return steamState.isLoading;
});

final steamUserDataProvider = Provider<SteamUserData?>((ref) {
  final steamState = ref.watch(steamConnectionProvider);
  return steamState.userData;
});

// Provider para auto-restaurar conexão se houver tokens salvos
final steamAutoRestoreProvider = FutureProvider<void>((ref) async {
  final steamNotifier = ref.read(steamConnectionProvider.notifier);

  if (await steamNotifier.hasValidSavedTokens()) {
    await steamNotifier.restoreConnection();
  }
});

// Provider conveniente para verificar se há tokens salvos
final hasSavedSteamTokensProvider = FutureProvider<bool>((ref) async {
  final steamNotifier = ref.read(steamConnectionProvider.notifier);
  return await steamNotifier.hasValidSavedTokens();
});
