// user_model.dart
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
import 'package:flutter_clean_arch_template/features/users/domain/user_entity.dart';

class UserModel {
  final String displayName;
  final String emailMasked;
  final String? avatarUrl;
  final UserRole? role;

  const UserModel({
    required this.displayName,
    required this.emailMasked,
    this.avatarUrl,
    this.role,
  });

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        displayName: entity.name.toUpperCase(),
        emailMasked: _maskEmail(entity.email),
        avatarUrl: entity.avatar ?? '/assets/images/default_avatar.png',
        role: entity.role,
      );

  static String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    return '${parts[0][0]}***@${parts[1]}';
  }

  //Getter que a UI pode chamar diretamente
  String get roleLabel => role!.label;
}
