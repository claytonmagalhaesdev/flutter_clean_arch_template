// lib/features/users/presentation/users_viewmodel.dart

import 'user_model.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';

/// Pure data holder com toda a lógica de apresentação:
/// - agrupa por role
/// - fornece helpers para UI
final class UsersViewModel {
  final List<UserModel> admins;
  final List<UserModel> regulars;
  final List<UserModel> guests;

  const UsersViewModel({
    this.admins = const [],
    this.regulars = const [],
    this.guests = const [],
  });

  /// Agrupa lista bruta em seções de acordo com UserRole
  factory UsersViewModel.fromModels(List<UserModel> all) {
    final admins = all.where((u) => u.role == UserRole.admin).toList();
    final guests = all.where((u) => u.role == UserRole.guest).toList();
    final regulars = all.where((u) => u.role == UserRole.regular).toList();
    return UsersViewModel(
      admins: admins,
      regulars: regulars,
      guests: guests,
    );
  }

  bool get hasAny =>
      admins.isNotEmpty || regulars.isNotEmpty || guests.isNotEmpty;
}
