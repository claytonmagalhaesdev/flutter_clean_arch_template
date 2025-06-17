enum EnumLanguage {
  english('en'),
  portuguese('pt'),
  japanese('ja');

  final String code;

  const EnumLanguage(this.code);
}

enum UserRole {
  admin,
  regular,
  guest,
}

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
