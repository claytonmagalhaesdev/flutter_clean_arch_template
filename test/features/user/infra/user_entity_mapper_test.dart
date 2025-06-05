import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_dto.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_entity_mapper.dart';

void main() {
  final mapper = UserEntityMapper();

  group('UserEntityMapper', () {
    test('toEntity should convert dto to entity', () {
      final dto = UserDto(
        id: 10,
        name: 'Anna',
        email: 'anna@test.com',
        token: 'token',
        refreshToken: 'refresh',
      );

      final entity = mapper.toEntity(dto);

      expect(entity.id, 10);
      expect(entity.name, 'Anna');
    });

    test('toDto should convert entity to dto', () {
      const entity = UserEntity(
        id: 10,
        name: 'Anna',
        email: 'anna@test.com',
        token: 'token',
        refreshToken: 'refresh',
      );

      final dto = mapper.toDto(entity);

      expect(dto.name, 'Anna');
      expect(dto.email, 'anna@test.com');
    });

    test('toEntityList should convert list of dtos', () {
      final dtos = [
        UserDto(id: 1, name: 'A', email: 'a@test.com'),
        UserDto(id: 2, name: 'B', email: 'b@test.com'),
      ];

      final entities = mapper.toEntityList(dtos);

      expect(entities.length, 2);
      expect(entities[0].name, 'A');
    });
  });
}
