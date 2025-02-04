import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/failures.dart';
import 'package:flutter_clean_arch_template/core/common/network/http/dio/dio_http_client.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_repository.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final DioHttpClient _dio;
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  const UserRepositoryImpl({required DioHttpClient dio}) : _dio = dio;

  @override
  Future<Result<List<UserEntity>>> getUsers() async {
    return _handleApiCall(() async {
      final response = await _dio.get('$_baseUrl/users');
      return _parseUsersList(response.data);
    });
  }

  List<UserEntity> _parseUsersList(dynamic data) {
    return (data as List)
        .map((user) => UserModel.fromJson(user))
        .map((user) => user.toEntity())
        .toList();
  }

  Future<Result<T>> _handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(
        NetworkFailure(
          e.response?.data['error'] ?? 'An unexpected error occurred.',
        ),
      );
    } catch (e) {
      return Result.error(UnknownFailure(e.toString()));
    }
  }
}
