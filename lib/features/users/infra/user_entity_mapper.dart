import 'package:flutter_clean_arch_template/core/common/domain/entity_mapper.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
import 'package:flutter_clean_arch_template/features/users/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_dto.dart';

final class UserEntityMapper extends EntityListMapper<UserDto, UserEntity> {
  @override
  UserEntity toEntity(UserDto dto) => UserEntity(
        id: dto.id ?? 0,
        name: dto.name,
        email: dto.email,
        role: userRoleFromString(dto.role),
        avatar: dto.avatar,
        token: dto.token,
        refreshToken: dto.refreshToken,
      );

  @override
  UserDto toDto(UserEntity entity) => UserDto(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        role: entity.role?.name,
        avatar: entity.avatar,
        token: entity.token,
        refreshToken: entity.refreshToken,
      );

  //Esse método não faz parte do contrato das interfaces 
  static UserRole userRoleFromString(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'guest':
        return UserRole.guest;
      default:
        return UserRole.regular;
    }
  }
}
