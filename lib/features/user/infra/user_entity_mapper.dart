import 'package:flutter_clean_arch_template/core/common/domain/entity_mapper.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_dto.dart';

final class UserEntityMapper extends EntityListMapper<UserDto, UserEntity> {
  @override
  UserEntity toEntity(UserDto dto) => UserEntity(
        id: dto.id ?? 0,
        name: dto.name,
        email: dto.email,
        avatar: dto.avatar,
        token: dto.token,
        refreshToken: dto.refreshToken,
      );

  @override
  UserDto toDto(UserEntity entity) => UserDto(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        avatar: entity.avatar,
        token: entity.token,
        refreshToken: entity.refreshToken,
      );
}
