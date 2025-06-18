import 'package:flutter_clean_arch_template/core/common/infra/network/http/api_url_configs.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/http_client.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/users/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/users/domain/user_repository.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_dto_mapper.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_entity_mapper.dart';

import 'package:flutter_clean_arch_template/core/common/extensions/future_result_extension.dart';

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
  Future<Result<List<UserEntity>>> getUsers() {
    final baseUrl = _apiConfig.getBaseUrl('jsonplaceholder');
    return _httpClient
        .get('$baseUrl/users')
        .then((r) => _userMapper.toDtoList(r.data))
        .then(_userEntityMapper.toEntityList)
        .asResult();
  }
}
