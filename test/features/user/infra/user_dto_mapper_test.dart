import 'package:flutter_clean_arch_template/features/users/infra/user_dto_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_dto.dart';

void main() {
  final mapper = UserDtoMapper();

  group('UserMapper', () {
    test('should convert JSON to UserDto correctly', () {
      final json = {
        'id': 1,
        'name': 'Alice',
        'email': 'alice@test.com',
        'avatar': 'avatar_url',
        'token': 'abc',
        'refreshToken': 'def',
      };

      final dto = mapper.toDto(json);

      expect(dto.id, 1);
      expect(dto.name, 'Alice');
      expect(dto.email, 'alice@test.com');
      expect(dto.avatar, 'avatar_url');
      expect(dto.token, 'abc');
      expect(dto.refreshToken, 'def');
    });

    test('should convert UserDto to JSON correctly', () {
      final dto = UserDto(
        id: 2,
        name: 'Bob',
        email: 'bob@test.com',
        avatar: 'img',
        token: 'xyz',
        refreshToken: 'rst',
      );

      final json = mapper.toJson(dto);

      expect(json['id'], 2);
      expect(json['name'], 'Bob');
      expect(json['email'], 'bob@test.com');
      expect(json['avatar'], 'img');
      expect(json['token'], 'xyz');
      expect(json['refreshToken'], 'rst');
    });

    test('should convert list of JSONs to list of UserDtos', () {
      final jsonList = [
        {'id': 1, 'name': 'A', 'email': 'a@test.com'},
        {'id': 2, 'name': 'B', 'email': 'b@test.com'},
      ];

      final dtos = mapper.toDtoList(jsonList);

      expect(dtos.length, 2);
      expect(dtos[0].name, 'A');
      expect(dtos[1].email, 'b@test.com');
    });
  });
}
