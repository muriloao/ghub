import 'package:hive/hive.dart';
import 'models/game_cache_model.dart';
import 'models/user_cache_model.dart';

/// Adapter manual para GameCacheModel
class GameCacheModelAdapter extends TypeAdapter<GameCacheModel> {
  @override
  final int typeId = 0;

  @override
  GameCacheModel read(BinaryReader reader) {
    return GameCacheModel(
      id: reader.readString(),
      name: reader.readString(),
      platform: reader.readString(),
      imageUrl: reader.readString(),
      playtimeMinutes: reader.readInt(),
      lastPlayed: reader.read() as DateTime?,
      metadata: Map<String, dynamic>.from(reader.readMap()),
      cachedAt: reader.read() as DateTime,
      isFavorite: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, GameCacheModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.platform);
    writer.writeString(obj.imageUrl ?? '');
    writer.writeInt(obj.playtimeMinutes);
    writer.write(obj.lastPlayed);
    writer.writeMap(obj.metadata);
    writer.write(obj.cachedAt);
    writer.writeBool(obj.isFavorite);
  }
}

/// Adapter manual para UserCacheModel
class UserCacheModelAdapter extends TypeAdapter<UserCacheModel> {
  @override
  final int typeId = 1;

  @override
  UserCacheModel read(BinaryReader reader) {
    return UserCacheModel(
      id: reader.readString(),
      name: reader.readString(),
      email: reader.readString(),
      avatarUrl: reader.readString(),
      createdAt: reader.read() as DateTime,
      updatedAt: reader.read() as DateTime,
      cachedAt: reader.read() as DateTime,
      metadata: Map<String, dynamic>.from(reader.readMap()),
    );
  }

  @override
  void write(BinaryWriter writer, UserCacheModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.avatarUrl ?? '');
    writer.write(obj.createdAt);
    writer.write(obj.updatedAt);
    writer.write(obj.cachedAt);
    writer.writeMap(obj.metadata);
  }
}
