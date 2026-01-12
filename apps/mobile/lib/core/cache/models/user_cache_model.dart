import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserCacheModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? avatarUrl;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final DateTime cachedAt;

  @HiveField(7)
  final Map<String, dynamic> metadata;

  UserCacheModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.cachedAt,
    this.metadata = const {},
  });

  UserCacheModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? cachedAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserCacheModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Verifica se o cache do usuário está expirado
  bool isExpired({Duration maxAge = const Duration(days: 7)}) {
    return DateTime.now().difference(cachedAt) > maxAge;
  }

  /// Converte para Map para compatibilidade
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'cachedAt': cachedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Cria a partir de um User domain entity
  factory UserCacheModel.fromUser(dynamic user) {
    return UserCacheModel(
      id: user.id,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      cachedAt: DateTime.now(),
      metadata: {},
    );
  }
}
