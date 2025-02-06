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

  test('should create a copy with updated properties', () {
    final user = UserEntity(
      id: 1,
      name: 'Buddy',
      email: 'email@email.com',
      avatar: 'avatar_teste',
      token: "abc123",
      refreshToken: "abc1234",
    );

    final updatedUser = user.copyWith(
      name: 'Max',
      email: "max@max.com",
    );

    expect(updatedUser.id, 1);
    expect(updatedUser.name, 'Max');
    expect(updatedUser.email, 'max@max.com');
    expect(updatedUser.avatar, 'avatar_teste');
    expect(updatedUser.token, "abc123");
    expect(updatedUser.refreshToken, "abc1234");
  });

  test('should create a copy with no changes if no arguments are provided', () {
    final user = UserEntity(
      id: 1,
      name: 'Buddy',
      email: 'email@email.com',
      avatar: 'avatar_teste',
      token: "abc123",
      refreshToken: "abc1234",
    );

    final copiedUser = user.copyWith();

    expect(copiedUser, user);
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
