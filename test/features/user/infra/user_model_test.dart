import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userJsonMandatory = {
    'id': '1',
    'name': 'Buddy',
    'email': 'email@email.com',
  };

  final userJson = {
    ...userJsonMandatory,
    'avatar': 'avatar_teste',
    'token': "abc123",
    'refreshToken': "abc1234",
  };

  final userModel = UserModel(
    id: '1',
    name: 'Buddy',
    email: 'email@email.com',
    avatar: 'avatar_teste',
    token: "abc123",
    refreshToken: "abc1234",
  );

  group('UserModel', () {
    test('fromJson should return a valid model with mandatory fields', () {
      final result = UserModel.fromJson(userJsonMandatory);
      expect(result, isA<UserModel>());
      expect(result.id, userJsonMandatory['id']);
      expect(result.name, userJsonMandatory['name']);
      expect(result.email, userJsonMandatory['email']);
    });

    test('fromJson should return a valid model', () {
      final result = UserModel.fromJson(userJson);
      expect(result, isA<UserModel>());
      expect(result.id, userJson['id']);
      expect(result.name, userJson['name']);
      expect(result.email, userJson['email'].toString());
      expect(result.avatar, userJson['avatar']);
      expect(result.token, userJson['token']);
      expect(result.refreshToken, userJson['refreshToken']);
    });

    test('toJson should return a valid JSON map', () {
      final result = userModel.toJson();
      expect(result, userJson);
    });

    test('toEntity should return a valid UserEntity', () {
      final result = userModel.toEntity();
      expect(result, isA<UserEntity>());
      expect(result.id, userModel.id);
      expect(result.name, userModel.name);
      expect(result.email, userModel.email);
      expect(result.avatar, userModel.avatar);
      expect(result.token, userModel.token);
      expect(result.refreshToken, userModel.refreshToken);
    });
  });
}
