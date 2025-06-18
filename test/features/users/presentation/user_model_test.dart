import 'package:flutter_clean_arch_template/features/users/presentation/user_role_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/user_model.dart';
import 'package:flutter_clean_arch_template/features/users/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';

void main() {
  group('UserModel', () {
    test('fromEntity should map fields correctly', () {
      final entity = UserEntity(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        avatar: 'avatar.png',
        role: UserRole.admin,
      );

      final model = UserModel.fromEntity(entity);

      expect(model.displayName, 'JOHN DOE');
      expect(model.emailMasked, 'j***@example.com');
      expect(model.avatarUrl, 'avatar.png');
      expect(model.role, UserRole.admin);
    });

    test('fromEntity should use default avatar if avatar is null', () {
      final entity = UserEntity(
        id: 2,
        name: 'Jane',
        email: 'jane@example.com',
        avatar: null,
        role: UserRole.admin,
      );

      final model = UserModel.fromEntity(entity);

      expect(model.avatarUrl, '/assets/images/default_avatar.png');
    });

    test('fromEntity should mask email correctly', () {
      final entity = UserEntity(
        id: 3,
        name: 'Bob',
        email: 'bob.smith@domain.com',
        avatar: null,
        role: UserRole.admin,
      );

      final model = UserModel.fromEntity(entity);

      expect(model.emailMasked, 'b***@domain.com');
    });

    test('fromEntity should return original email if email is invalid', () {
      final entity = UserEntity(
        id: 4,
        name: 'Invalid',
        email: 'invalidemail',
        avatar: null,
        role: UserRole.admin,
      );

      final model = UserModel.fromEntity(entity);

      expect(model.emailMasked, 'invalidemail');
    });

    test('roleLabel should return correct label', () {
      final model = UserModel(
        displayName: 'Test',
        emailMasked: 't***@mail.com',
        avatarUrl: null,
        role: UserRole.admin,
      );

      expect(model.roleLabel, UserRole.admin.label);
    });
  });
}
