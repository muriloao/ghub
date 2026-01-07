import 'package:flutter_test/flutter_test.dart';
import 'package:ghub_mobile/features/auth/domain/entities/user.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('User', () {
    test('should create User from JSON correctly', () {
      // arrange
      final json = TestFixtures.userJson;

      // act
      final user = User.fromJson(json);

      // assert
      expect(user.id, TestFixtures.userId);
      expect(user.email, TestFixtures.validEmail);
      expect(user.name, TestFixtures.userName);
      expect(user.avatarUrl, TestFixtures.userAvatarUrl);
      expect(user.createdAt, DateTime.parse('2024-01-01T00:00:00Z'));
      expect(user.updatedAt, DateTime.parse('2024-01-01T00:00:00Z'));
    });

    test('should handle null name and avatarUrl', () {
      // arrange
      final json = Map<String, dynamic>.from(TestFixtures.userJson);
      json.remove('name');
      json.remove('avatar_url');

      // act
      final user = User.fromJson(json);

      // assert
      expect(user.name, null);
      expect(user.avatarUrl, null);
      expect(user.id, TestFixtures.userId);
      expect(user.email, TestFixtures.validEmail);
    });

    test('should convert User to JSON correctly', () {
      // arrange
      final user = User.fromJson(TestFixtures.userJson);

      // act
      final json = user.toJson();

      // assert
      expect(json['id'], TestFixtures.userId);
      expect(json['email'], TestFixtures.validEmail);
      expect(json['name'], TestFixtures.userName);
      expect(json['avatar_url'], TestFixtures.userAvatarUrl);
      expect(json['created_at'], '2024-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2024-01-01T00:00:00.000Z');
    });

    test('should support equality comparison', () {
      // arrange
      final user1 = User.fromJson(TestFixtures.userJson);
      final user2 = User.fromJson(TestFixtures.userJson);
      final differentUser = User.fromJson({
        ...TestFixtures.userJson,
        'id': 'different-id',
      });

      // assert
      expect(user1, equals(user2));
      expect(user1, isNot(equals(differentUser)));
    });

    test('should have proper props for Equatable', () {
      // arrange
      final user = User.fromJson(TestFixtures.userJson);

      // assert
      expect(user.props, [
        TestFixtures.userId,
        TestFixtures.validEmail,
        TestFixtures.userName,
        TestFixtures.userAvatarUrl,
        DateTime.parse('2024-01-01T00:00:00Z'),
        DateTime.parse('2024-01-01T00:00:00Z'),
      ]);
    });

    test('should create copy with updated fields', () {
      // arrange
      final user = User.fromJson(TestFixtures.userJson);

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