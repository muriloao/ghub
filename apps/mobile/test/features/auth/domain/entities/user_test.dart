import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/features/auth/domain/entities/user.dart';

void main() {
  group('User', () {
    test('should create User from JSON correctly', () {
      // arrange
      final json = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'avatar_url': 'https://example.com/avatar.jpg',
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      // act
      final user = User.fromJson(json);

      // assert
      expect(user.id, 'test-user-id');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.createdAt, DateTime.parse('2024-01-01T00:00:00Z'));
      expect(user.updatedAt, DateTime.parse('2024-01-01T00:00:00Z'));
    });

    test('should handle null name and avatarUrl', () {
      // arrange
      final json = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      // act
      final user = User.fromJson(json);

      // assert
      expect(user.name, null);
      expect(user.avatarUrl, null);
      expect(user.id, 'test-user-id');
      expect(user.email, 'test@example.com');
    });

    test('should convert User to JSON correctly', () {
      // arrange
      final inputJson = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };
      final user = User.fromJson(inputJson);

      // act
      final outputJson = user.toJson();

      // assert
      expect(outputJson['id'], 'test-user-id');
      expect(outputJson['email'], 'test@example.com');
      expect(outputJson['name'], 'Test User');
      expect(outputJson['avatarUrl'], 'https://example.com/avatar.jpg');
      expect(outputJson['createdAt'], '2024-01-01T00:00:00.000Z');
      expect(outputJson['updatedAt'], '2024-01-01T00:00:00.000Z');
    });

    test('should support equality comparison', () {
      // arrange
      final json = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };
      final user1 = User.fromJson(json);
      final user2 = User.fromJson(json);
      final differentUser = User.fromJson({...json, 'id': 'different-id'});

      // assert
      expect(user1, equals(user2));
      expect(user1, isNot(equals(differentUser)));
    });

    test('should have proper props for Equatable', () {
      // arrange
      final json = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };
      final user = User.fromJson(json);

      // assert
      expect(user.props, [
        'test-user-id',
        'test@example.com',
        'Test User',
        'https://example.com/avatar.jpg',
        DateTime.parse('2024-01-01T00:00:00Z'),
        DateTime.parse('2024-01-01T00:00:00Z'),
      ]);
    });

    test('should create copy with updated fields', () {
      // arrange
      final json = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };
      final user = User.fromJson(json);

      // act
      final updatedUser = user.copyWith(
        name: 'Updated Name',
        avatarUrl: 'https://newavatar.com/avatar.jpg',
      );

      // assert
      expect(updatedUser.name, 'Updated Name');
      expect(updatedUser.avatarUrl, 'https://newavatar.com/avatar.jpg');
      expect(updatedUser.id, user.id);
      expect(updatedUser.email, user.email);
      expect(updatedUser.createdAt, user.createdAt);
      expect(updatedUser.updatedAt, user.updatedAt);
    });
  });
}
