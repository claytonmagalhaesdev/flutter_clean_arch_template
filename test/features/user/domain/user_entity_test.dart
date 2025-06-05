import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserEntity', () {
    test('should create a UserEntity with correct properties', () {
      final user = UserEntity(
        id: 1,
        name: 'Tom Brady',
        email: 'email@email.com',
        avatar: 'avatar_teste',
        token: "abc123",
        refreshToken: "abc1234",
      );

      expect(user.id, 1);
      expect(user.name, 'Tom Brady');
      expect(user.email, 'email@email.com');
      expect(user.avatar, "avatar_teste");
      expect(user.token, "abc123");
      expect(user.refreshToken, "abc1234");
    });

    test('should return true if token is present and not empty', () {
      final user = UserEntity(
        id: 1,
        name: 'Test',
        email: 'test@email.com',
        token: 'abc123',
      );

      expect(user.isAuthenticated, isTrue);
    });

    test('should return false if token is null or empty', () {
      final userWithoutToken = UserEntity(
        id: 2,
        name: 'NoToken',
        email: 'no@token.com',
        token: null,
      );

      final userWithEmptyToken = UserEntity(
        id: 3,
        name: 'Empty',
        email: 'empty@token.com',
        token: '',
      );

      expect(userWithoutToken.isAuthenticated, isFalse);
      expect(userWithEmptyToken.isAuthenticated, isFalse);
    });

    test('should support value equality', () {
      final user1 = UserEntity(
        id: 1,
        name: 'Buddy',
        email: 'email@email.com',
        avatar: 'avatar_teste',
        token: "abc123",
        refreshToken: "abc1234",
      );

      final user2 = UserEntity(
        id: 1,
        name: 'Buddy',
        email: 'email@email.com',
        avatar: 'avatar_teste',
        token: "abc123",
        refreshToken: "abc1234",
      );

      expect(user1, user2);
    });
  });

  test('should return correct hashCode', () {
    final user = UserEntity(
      id: 1,
      name: 'Buddy',
      email: 'email@email.com',
      avatar: 'avatar_teste',
      token: "abc123",
      refreshToken: "abc1234",
    );

    final expectedHashCode = user.id.hashCode ^
        user.name.hashCode ^
        user.email.hashCode ^
        user.avatar.hashCode ^
        user.token.hashCode ^
        user.refreshToken.hashCode;

    expect(user.hashCode, expectedHashCode);
  });

  test('should return correct string (toString) representation', () {
    final user = UserEntity(
      id: 1,
      name: 'Buddy',
      email: 'email@email.com',
      avatar: 'avatarteste',
      token: 'abc123',
      refreshToken: 'abc1234',
    );

    final expectedString =
        "UserEntity(id: 1, name: Buddy, email: email@email.com, avatar: avatarteste, token: abc123, refreshToken: abc1234)";

    expect(user.toString(), expectedString);
  });
}
