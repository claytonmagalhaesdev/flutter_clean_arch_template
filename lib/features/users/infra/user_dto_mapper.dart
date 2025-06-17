import 'package:flutter_clean_arch_template/core/common/infra/dto_mapper.dart';
import 'package:flutter_clean_arch_template/core/common/types/types.dart';
import 'user_dto.dart';

final class UserDtoMapper extends ListMapper<UserDto> {
  @override
  UserDto toDto(Json json) => UserDto(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        avatar: json['avatar'],
        token: json['token'],
        refreshToken: json['refreshToken'],
      );

  @override
  Json toJson(UserDto dto) => {
        'id': dto.id,
        'name': dto.name,
        'email': dto.email,
        'role': dto.role,
        'avatar': dto.avatar,
        'token': dto.token,
        'refreshToken': dto.refreshToken,
      };
}
