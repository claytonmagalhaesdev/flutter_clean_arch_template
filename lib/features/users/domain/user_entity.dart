import 'package:flutter_clean_arch_template/core/common/types/enums.dart';

final class UserEntity {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? token;
  final String? refreshToken;
  final UserRole? role;

  const UserEntity(
      {required this.id,
      required this.name,
      required this.email,
      this.role,
      this.avatar,
      this.token,
      this.refreshToken});

  /// Regras de domínio: usuário está autenticado se tiver token válido
  bool get isAuthenticated => token != null && token!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          role == other.role &&
          token == other.token &&
          refreshToken == other.refreshToken &&
          avatar == other.avatar;

  @override
  int get hashCode =>
      Object.hash(id, name, email, role, avatar, token, refreshToken);

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, role: $role, avatar: $avatar, token: $token, refreshToken: $refreshToken)';
  }
}
