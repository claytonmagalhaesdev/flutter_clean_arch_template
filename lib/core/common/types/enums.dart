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
