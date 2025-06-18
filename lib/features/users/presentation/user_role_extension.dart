import 'package:flutter_clean_arch_template/core/common/types/enums.dart';

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.regular:
        return 'Regular';
      case UserRole.guest:
        return 'Convidado';
    }
  }
}
