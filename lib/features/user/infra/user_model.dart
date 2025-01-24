import 'package:flutter_clean_arch_template/core/commom/types/types.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? token;
  final String? refreshToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.token,
    this.refreshToken,
  });

  factory UserModel.fromJson(Json json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'token': token,
      'refreshToken': refreshToken,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      token: token,
      refreshToken: refreshToken,
    );
  }
}
