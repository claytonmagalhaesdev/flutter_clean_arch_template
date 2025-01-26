import 'package:flutter_clean_arch_template/core/commom/types/types.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';

class UserModel {
  String? id;
  String name;
  String email;
  String? avatar;
  String? token;
  String? refreshToken;

  UserModel({
    this.id,
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
      id: id ?? '',
      name: name,
      email: email,
      avatar: avatar,
      token: token,
      refreshToken: refreshToken,
    );
  }
}
