class UserDto {
  int? id;
  String name;
  String email;
  String? avatar;
  String? token;
  String? refreshToken;

  UserDto({
    this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.token,
    this.refreshToken,
  });
}
