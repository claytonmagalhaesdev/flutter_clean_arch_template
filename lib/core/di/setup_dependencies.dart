// lib/app_module.dart
import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/core/di/dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/dio/dio_http_client.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_dto_mapper.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_entity_mapper.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_repository_impl.dart';
import 'package:flutter_clean_arch_template/features/users/domain/usecases/get_users_use_case.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/api_url_configs.dart';

void setupDependencies(DependencyInjector di) async {
  // Internacionalização
  final localizationService = LocalizationService.instance;
  di.registerSingleton<LocalizationService>(localizationService);

  await localizationService.initialize();

  // Configurações de rede
  di.registerSingleton<Dio>(Dio());
  di.registerSingleton<DioHttpClient>(DioHttpClient(di.get<Dio>()));
  di.registerSingleton<ApiUrlConfigs>(ApiConfigRepositoryImpl());

  //mappers
  di.registerSingleton<UserDtoMapper>(UserDtoMapper());
  di.registerSingleton<UserEntityMapper>(UserEntityMapper());

  // Repositórios
  di.registerSingleton<UserRepositoryImpl>(UserRepositoryImpl(
      httpClient: di.get<DioHttpClient>(),
      apiConfig: di.get<ApiUrlConfigs>(),
      mapper: di.get<UserDtoMapper>(),
      userEntityMapper: di.get<UserEntityMapper>()));

  // Casos de uso
  di.registerFactory<GetUsersUseCase>(
      () => GetUsersUseCase(di.get<UserRepositoryImpl>()));

 
}
