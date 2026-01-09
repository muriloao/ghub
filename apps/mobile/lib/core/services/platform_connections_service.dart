import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlatformConnectionData {
  final String platformId;
  final String platformName;
  final String? username;
  final String? userId;
  final Map<String, dynamic> tokens;
  final DateTime connectedAt;
  final Map<String, dynamic> metadata;

  const PlatformConnectionData({
    required this.platformId,
    required this.platformName,
    this.username,
    this.userId,
    required this.tokens,
    required this.connectedAt,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'platformId': platformId,
      'platformName': platformName,
      'username': username,
      'userId': userId,
      'tokens': tokens,
      'connectedAt': connectedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory PlatformConnectionData.fromJson(Map<String, dynamic> json) {
    return PlatformConnectionData(
      platformId: json['platformId'],
      platformName: json['platformName'],
      username: json['username'],
      userId: json['userId'],
      tokens: Map<String, dynamic>.from(json['tokens'] ?? {}),
      connectedAt: DateTime.parse(json['connectedAt']),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

class PlatformConnectionsService {
  static const String _connectionsKey = 'platform_connections';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Salva uma conexão de plataforma
  static Future<void> saveConnection(PlatformConnectionData connection) async {
    try {
      final connections = await getConnections();

      // Remove conexão existente se houver
      connections.removeWhere((c) => c.platformId == connection.platformId);

      // Adiciona nova conexão
      connections.add(connection);

      // Salva no storage seguro
      final connectionsJson = connections.map((c) => c.toJson()).toList();
      await _secureStorage.write(
        key: _connectionsKey,
        value: jsonEncode(connectionsJson),
      );
    } catch (e) {
      throw Exception('Erro ao salvar conexão: $e');
    }
  }

  /// Recupera todas as conexões salvas
  static Future<List<PlatformConnectionData>> getConnections() async {
    try {
      final connectionsString = await _secureStorage.read(key: _connectionsKey);

      if (connectionsString == null) {
        return [];
      }

      final List<dynamic> connectionsJson = jsonDecode(connectionsString);
      return connectionsJson
          .map((json) => PlatformConnectionData.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Verifica se uma plataforma está conectada
  static Future<bool> isConnected(String platformId) async {
    final connections = await getConnections();
    return connections.any((c) => c.platformId == platformId);
  }

  /// Obtém dados de conexão de uma plataforma específica
  static Future<PlatformConnectionData?> getConnection(
    String platformId,
  ) async {
    final connections = await getConnections();
    try {
      return connections.firstWhere((c) => c.platformId == platformId);
    } catch (e) {
      return null;
    }
  }

  /// Remove uma conexão de plataforma
  static Future<void> removeConnection(String platformId) async {
    try {
      final connections = await getConnections();
      connections.removeWhere((c) => c.platformId == platformId);

      if (connections.isEmpty) {
        await _secureStorage.delete(key: _connectionsKey);
      } else {
        final connectionsJson = connections.map((c) => c.toJson()).toList();
        await _secureStorage.write(
          key: _connectionsKey,
          value: jsonEncode(connectionsJson),
        );
      }
    } catch (e) {
      throw Exception('Erro ao remover conexão: $e');
    }
  }

  /// Remove todas as conexões
  static Future<void> clearAllConnections() async {
    await _secureStorage.delete(key: _connectionsKey);
  }

  /// Obtém lista de plataformas conectadas (apenas IDs)
  static Future<Set<String>> getConnectedPlatformIds() async {
    final connections = await getConnections();
    return connections.map((c) => c.platformId).toSet();
  }

  /// Atualiza tokens de uma plataforma existente
  static Future<void> updateTokens(
    String platformId,
    Map<String, dynamic> newTokens,
  ) async {
    final connection = await getConnection(platformId);
    if (connection != null) {
      final updatedConnection = PlatformConnectionData(
        platformId: connection.platformId,
        platformName: connection.platformName,
        username: connection.username,
        userId: connection.userId,
        tokens: {...connection.tokens, ...newTokens},
        connectedAt: connection.connectedAt,
        metadata: connection.metadata,
      );
      await saveConnection(updatedConnection);
    }
  }

  /// Atualiza metadados de uma plataforma
  static Future<void> updateMetadata(
    String platformId,
    Map<String, dynamic> newMetadata,
  ) async {
    final connection = await getConnection(platformId);
    if (connection != null) {
      final updatedConnection = PlatformConnectionData(
        platformId: connection.platformId,
        platformName: connection.platformName,
        username: connection.username,
        userId: connection.userId,
        tokens: connection.tokens,
        connectedAt: connection.connectedAt,
        metadata: {...connection.metadata, ...newMetadata},
      );
      await saveConnection(updatedConnection);
    }
  }
}
