// user_model.dart
import 'package:flutter_clean_arch_template/features/users/domain/user_entity.dart';

class UserModel {
  final String displayName;
  final String emailMasked;
  final String? avatarUrl;

  const UserModel({
    required this.displayName,
    required this.emailMasked,
    this.avatarUrl,
  });

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        displayName: entity.name.toUpperCase(),
        emailMasked: _maskEmail(entity.email),
        avatarUrl: entity.avatar ?? '/assets/images/default_avatar.png',
      );

  static String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    return '${parts[0][0]}***@${parts[1]}';
  }
}
