import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/platform_connections_service.dart';

// Estados da conexão Epic Games
enum EpicConnectionStatus { idle, connecting, polling, success, error }

class EpicConnectionState {
  final EpicConnectionStatus status;
  final String? sessionId;
  final String? epicAccountId;
  final EpicUserData? userData;
  final String? error;

  const EpicConnectionState({
    required this.status,
    this.sessionId,
    this.epicAccountId,
    this.userData,
    this.error,
  });

  EpicConnectionState copyWith({
    EpicConnectionStatus? status,
    String? sessionId,
    String? epicAccountId,
    EpicUserData? userData,
    String? error,
  }) {
    return EpicConnectionState(
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      epicAccountId: epicAccountId ?? this.epicAccountId,
      userData: userData ?? this.userData,
      error: error ?? this.error,
    );
  }

  bool get isConnected => status == EpicConnectionStatus.success;
  bool get isLoading =>
      status == EpicConnectionStatus.connecting ||
      status == EpicConnectionStatus.polling;
}

class EpicUserData {
  final String displayName;
  final String email;
  final String? avatar;
  final String locale;

  const EpicUserData({
    required this.displayName,
    required this.email,
    this.avatar,
    required this.locale,
  });

  factory EpicUserData.fromJson(Map<String, dynamic> json) {
    return EpicUserData(
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      locale: json['locale'] ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'avatar': avatar,
      'locale': locale,
    };
  }
}

// Notifier para gerenciar conexão Epic Games
class EpicConnectionNotifier extends StateNotifier<EpicConnectionState> {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  Timer? _pollingTimer;

  // Configurações
  static const Duration _pollingInterval = Duration(seconds: 2);
  static const Duration _maxPollingDuration = Duration(minutes: 10);

  // Keys para armazenamento seguro
  static const String _epicAccessTokenKey = 'epic_access_token';
  static const String _epicRefreshTokenKey = 'epic_refresh_token';
  static const String _epicUserDataKey = 'epic_user_data';
  static const String _epicAccountIdKey = 'epic_account_id';

  EpicConnectionNotifier(this._dio, this._secureStorage)
    : super(const EpicConnectionState(status: EpicConnectionStatus.idle));

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  /// Inicia processo de conexão Epic Games
  Future<void> connectEpic() async {
    try {
      state = state.copyWith(
        status: EpicConnectionStatus.connecting,
        error: null,
      );

      // Solicitar início da conexão ao backend
      final response = await _dio.get(
        '${AppConstants.baseUrl}/auth/epic/start',
      );

      final sessionId = response.data['sessionId'] as String;
      final authUrl = response.data['authUrl'] as String;

      // Atualizar estado com session ID
      state = state.copyWith(
        status: EpicConnectionStatus.polling,
        sessionId: sessionId,
      );

      // Abrir URL de autenticação Epic Games
      final uri = Uri.parse(authUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Iniciar polling para verificar status
        _startPolling();
      } else {
        throw Exception('Não foi possível abrir URL de autenticação');
      }

      print('🎮 Epic Games: Processo de conexão iniciado');
    } catch (e) {
      state = state.copyWith(
        status: EpicConnectionStatus.error,
        error: 'Erro ao iniciar conexão Epic Games: $e',
      );
      print('❌ Epic Games: Erro na conexão - $e');
    }
  }

  /// Inicia polling para verificar status da conexão
  void _startPolling() {
    _pollingTimer?.cancel();

    final startTime = DateTime.now();

    _pollingTimer = Timer.periodic(_pollingInterval, (timer) async {
      // Verificar timeout
      if (DateTime.now().difference(startTime) > _maxPollingDuration) {
        timer.cancel();
        state = state.copyWith(
          status: EpicConnectionStatus.error,
          error: 'Timeout: Conexão Epic Games não foi completada',
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
        '${AppConstants.baseUrl}/auth/epic/status/${state.sessionId}',
      );

      final data = response.data;
      final status = data['status'] as String;

      switch (status) {
        case 'success':
          _pollingTimer?.cancel();

          final userData = data['userData'] != null
              ? EpicUserData.fromJson(data['userData'])
              : null;

          final epicAccountId = data['epicAccountId'] as String?;

          // Salvar dados de forma segura
          if (userData != null && epicAccountId != null) {
            await _saveConnectionSecurely(epicAccountId, userData);
          }

          state = state.copyWith(
            status: EpicConnectionStatus.success,
            epicAccountId: epicAccountId,
            userData: userData,
          );

          print('✅ Epic Games: Conexão realizada com sucesso');
          break;

        case 'error':
          _pollingTimer?.cancel();
          state = state.copyWith(
            status: EpicConnectionStatus.error,
            error: data['error'] ?? 'Erro desconhecido Epic Games',
          );
          print('❌ Epic Games: ${data['error']}');
          break;

        case 'pending':
          // Continuar polling
          break;
      }
    } catch (e) {
      print('⚠️ Epic Games: Erro ao verificar status - $e');
    }
  }

  /// Desconecta da Epic Games
  Future<void> disconnect() async {
    _pollingTimer?.cancel();

    // Limpar dados salvos
    await _clearSavedData();

    state = const EpicConnectionState(status: EpicConnectionStatus.idle);
    print('🔌 Epic Games: Desconectado');
  }

  /// Salva dados de conexão de forma segura
  Future<void> _saveConnectionSecurely(
    String epicAccountId,
    EpicUserData userData,
  ) async {
    try {
      // Salvar no FlutterSecureStorage
      await _secureStorage.write(key: _epicAccountIdKey, value: epicAccountId);

      // Salvar dados do usuário (sem tokens sensíveis)
      final userDataToSave = userData.toJson();
      await _secureStorage.write(
        key: _epicUserDataKey,
        value: json.encode(userDataToSave),
      );

      // IMPORTANTE: Também salvar no PlatformConnectionsService para integração
      final platformConnection = PlatformConnectionData(
        platformId: 'epic',
        platformName: 'Epic Games',
        username: userData.displayName,
        userId: epicAccountId,
        tokens: {
          // Tokens serão salvos quando disponíveis
        },
        connectedAt: DateTime.now(),
        metadata: {
          'epicAccountId': epicAccountId,
          'displayName': userData.displayName,
          'email': userData.email,
          'avatar': userData.avatar,
          'locale': userData.locale,
        },
      );

      await PlatformConnectionsService.saveConnection(platformConnection);
      print('✅ Conexão Epic Games salva no PlatformConnectionsService');

      print('✅ Epic Games: Dados salvos de forma segura');
    } catch (e) {
      print('❌ Epic Games: Erro ao salvar dados - $e');
    }
  }

  /// Limpa todos os dados salvos
  Future<void> _clearSavedData() async {
    try {
      await _secureStorage.delete(key: _epicAccountIdKey);
      await _secureStorage.delete(key: _epicAccessTokenKey);
      await _secureStorage.delete(key: _epicRefreshTokenKey);
      await _secureStorage.delete(key: _epicUserDataKey);

      // Também remover do PlatformConnectionsService
      await PlatformConnectionsService.removeConnection('epic');

      print('🗑️ Epic Games: Dados removidos de todos os storages');
    } catch (e) {
      print('❌ Epic Games: Erro ao limpar dados - $e');
    }
  }

  /// Recupera dados salvos (para reconexão automática)
  Future<Map<String, String?>> getSavedData() async {
    try {
      return {
        'epicAccountId': await _secureStorage.read(key: _epicAccountIdKey),
        'userData': await _secureStorage.read(key: _epicUserDataKey),
        'accessToken': await _secureStorage.read(key: _epicAccessTokenKey),
        'refreshToken': await _secureStorage.read(key: _epicRefreshTokenKey),
      };
    } catch (e) {
      return {};
    }
  }

  /// Verifica se existem dados válidos salvos
  Future<bool> hasValidSavedData() async {
    try {
      // Primeiro, verificar no FlutterSecureStorage
      final data = await getSavedData();
      if (data['epicAccountId'] != null && data['userData'] != null) {
        return true;
      }

      // Se não encontrar, verificar no PlatformConnectionsService
      final isConnected = await PlatformConnectionsService.isConnected('epic');
      return isConnected;
    } catch (e) {
      return false;
    }
  }

  /// Restaura conexão a partir de dados salvos
  Future<void> restoreConnection() async {
    try {
      // Primeiro, tentar do FlutterSecureStorage
      final data = await getSavedData();

      if (data['epicAccountId'] != null && data['userData'] != null) {
        final userDataJson = json.decode(data['userData']!);
        final userData = EpicUserData.fromJson(userDataJson);

        state = state.copyWith(
          status: EpicConnectionStatus.success,
          epicAccountId: data['epicAccountId'],
          userData: userData,
        );

        print('🔄 Epic Games: Conexão restaurada do FlutterSecureStorage');
        return;
      }

      // Se não encontrar, tentar do PlatformConnectionsService
      final platformConnection = await PlatformConnectionsService.getConnection(
        'epic',
      );

      if (platformConnection != null) {
        final userData = EpicUserData(
          displayName: platformConnection.metadata['displayName'] ?? '',
          email: platformConnection.metadata['email'] ?? '',
          avatar: platformConnection.metadata['avatar'],
          locale: platformConnection.metadata['locale'] ?? 'en',
        );

        state = state.copyWith(
          status: EpicConnectionStatus.success,
          epicAccountId: platformConnection.userId,
          userData: userData,
        );

        print(
          '🔄 Epic Games: Conexão restaurada do PlatformConnectionsService',
        );
      }
    } catch (e) {
      print('❌ Epic Games: Erro ao restaurar conexão - $e');
    }
  }

  /// Retry conexão em caso de erro
  Future<void> retry() async {
    if (state.status == EpicConnectionStatus.error) {
      await connectEpic();
    }
  }
}

// Provider principal da conexão Epic Games
final epicConnectionProvider =
    StateNotifierProvider<EpicConnectionNotifier, EpicConnectionState>((ref) {
      final dio = Dio();
      const secureStorage = FlutterSecureStorage(
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
      return EpicConnectionNotifier(dio, secureStorage);
    });

// Providers convenientes para UI
final isEpicConnectedProvider = Provider<bool>((ref) {
  final epicState = ref.watch(epicConnectionProvider);
  return epicState.isConnected;
});

final isEpicLoadingProvider = Provider<bool>((ref) {
  final epicState = ref.watch(epicConnectionProvider);
  return epicState.isLoading;
});

final epicUserDataProvider = Provider<EpicUserData?>((ref) {
  final epicState = ref.watch(epicConnectionProvider);
  return epicState.userData;
});

// Provider para auto-restaurar conexão se houver dados salvos
final epicAutoRestoreProvider = FutureProvider<void>((ref) async {
  final epicNotifier = ref.read(epicConnectionProvider.notifier);

  if (await epicNotifier.hasValidSavedData()) {
    await epicNotifier.restoreConnection();
  }
});

// Provider conveniente para verificar se há dados salvos
final hasSavedEpicDataProvider = FutureProvider<bool>((ref) async {
  final epicNotifier = ref.read(epicConnectionProvider.notifier);
  return await epicNotifier.hasValidSavedData();
});
