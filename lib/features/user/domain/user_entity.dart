class UserEntity {
  final String id;
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
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      token.hashCode ^
      refreshToken.hashCode ^
      avatar.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, avatar: $avatar, token: $token, refreshToken: $refreshToken)';
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? refreshToken,
    String? avatar,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      avatar: avatar ?? this.avatar,
    );
  }
}
