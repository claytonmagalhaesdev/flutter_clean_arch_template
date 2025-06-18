// test/features/users/presentation/users_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/user_model.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_viewmodel.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';

void main() {
  group('UsersViewModel', () {
    final admin1 = UserModel(
      displayName: 'Admin One',
      emailMasked: 'a***@example.com',
      avatarUrl: null,
      role: UserRole.admin,
    );

    final guest1 = UserModel(
      displayName: 'Guest One',
      emailMasked: 'g***@example.com',
      avatarUrl: null,
      role: UserRole.guest,
    );

    final regular1 = UserModel(
      displayName: 'Regular One',
      emailMasked: 'r***@example.com',
      avatarUrl: null,
      role: UserRole.regular,
    );

    test('fromModels should group users correctly by role', () {
      final all = [admin1, guest1, regular1, admin1, guest1];

      final vm = UsersViewModel.fromModels(all);

      expect(vm.admins, equals([admin1, admin1]));
      expect(vm.guests, equals([guest1, guest1]));
      expect(vm.regulars, equals([regular1]));
    });

    test('hasAny is false when all lists are empty', () {
      final vm = const UsersViewModel();
      expect(vm.hasAny, isFalse);
    });

    test('hasAny is true when any group is non-empty', () {
      expect(
        UsersViewModel.fromModels([admin1]).hasAny,
        isTrue,
      );
      expect(
        UsersViewModel.fromModels([guest1]).hasAny,
        isTrue,
      );
      expect(
        UsersViewModel.fromModels([regular1]).hasAny,
        isTrue,
      );
    });

    test('preserves order of users within each group', () {
      final uA = admin1;
      final uB = UserModel(
        displayName: 'Admin Two',
        emailMasked: 'a2***@example.com',
        avatarUrl: null,
        role: UserRole.admin,
      );
      final vm = UsersViewModel.fromModels([uA, uB, uA]);
      expect(vm.admins, equals([uA, uB, uA]));
    });
  });
}
