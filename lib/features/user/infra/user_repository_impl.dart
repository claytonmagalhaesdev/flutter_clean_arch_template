import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/types/failures.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/api_url_configs.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/http_client.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_repository.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpClient _httpClient;
  final ApiUrlConfigs _apiConfig;

  UserRepositoryImpl({
    required HttpClient httpClient,
    required ApiUrlConfigs apiConfig,
  })  : _httpClient = httpClient,
        _apiConfig = apiConfig;

  @override
  Future<Result<List<UserEntity>>> getUsers() async {
    try {
      final baseUrl = _apiConfig.getBaseUrl('jsonplaceholder');
      final response = await _httpClient.get('$baseUrl/users');
      final data = UserModel.toEntityList(response.data);
      return Result.ok(data);
    } on DioException catch (e) {
      return Result.error(
        NetworkFailure(
          e.response?.data['error'] ?? 'An unexpected error occurred.',
        ),
      );
    } catch (e) {
      print(e.toString());
      return Result.error(UnknownFailure(e.toString()));
    }
  }
}
