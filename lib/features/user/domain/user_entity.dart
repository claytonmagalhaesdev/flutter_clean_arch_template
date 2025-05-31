final class UserEntity {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? token;
  final String? refreshToken;

  const UserEntity(
      {required this.id,
      required this.name,
      required this.email,
      this.avatar,
      this.token,
      this.refreshToken});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          token == other.token &&
          refreshToken == other.refreshToken &&
          avatar == other.avatar;

  @override
  int get hashCode => Object.hash(id, name, email, avatar, token, refreshToken);

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, avatar: $avatar, token: $token, refreshToken: $refreshToken)';
  }
}
