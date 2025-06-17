class UserDto {
  int? id;
  String name;
  String email;
  String? avatar;
  String? token;
  String? refreshToken;
  String? role;

  UserDto({
    this.id,
    required this.name,
    required this.email,
    this.role,
    this.avatar,
    this.token,
    this.refreshToken,
  });
}
