import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/failures.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_repository.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final Dio _dio;

  const UserRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Result<List<UserEntity>>> getUsers() async {
    try {
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/users');
      final users = (response.data as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
      final usersList = users.map((user) => user.toEntity()).toList();
      return Result.ok(usersList);
    } on DioException catch (e) {
      return Result.error(NetworkFailure(
        e.response?.data['error'] ?? 'An unexpected error occurred.',
      ));
    }
  }
}
