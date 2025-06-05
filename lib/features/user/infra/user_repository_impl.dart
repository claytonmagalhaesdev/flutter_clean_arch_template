import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/types/failures.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/api_url_configs.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/http_client.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_repository.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_dto.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_dto_mapper.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_entity_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpClient _httpClient;
  final ApiUrlConfigs _apiConfig;
  final UserDtoMapper _userMapper;
  final UserEntityMapper _userEntityMapper;

  UserRepositoryImpl(
      {required HttpClient httpClient,
      required ApiUrlConfigs apiConfig,
      required UserDtoMapper mapper,
      required UserEntityMapper userEntityMapper})
      : _httpClient = httpClient,
        _apiConfig = apiConfig,
        _userMapper = mapper,
        _userEntityMapper = userEntityMapper;

  @override
  Future<Result<List<UserEntity>>> getUsers() async {
    try {
      final baseUrl = _apiConfig.getBaseUrl('jsonplaceholder');
      final response = await _httpClient.get('$baseUrl/users');
      // 1. Converte JSON → Dto
      final List<UserDto> dtos = _userMapper.toDtoList(response.data);

      // 2. Converte Dto → Entity
      final List<UserEntity> entities = _userEntityMapper.toEntityList(dtos);

      return Result.ok(entities);
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
