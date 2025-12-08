// lib/app_module.dart
import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/core/di/dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/dio/dio_http_client.dart';
import 'package:flutter_clean_arch_template/core/navigation/navigation_service.dart';
import 'package:flutter_clean_arch_template/core/navigation/page_factory.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_dto_mapper.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_entity_mapper.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_repository_impl.dart';
import 'package:flutter_clean_arch_template/features/users/domain/usecases/get_users_use_case.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/api_url_configs.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_cn_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_presenter.dart';
//import 'package:flutter_clean_arch_template/features/users/presentation/users_rx_presenter.dart';
import 'package:flutter/material.dart';

void setupDependencies(DependencyInjector di) async {
  //navigation feature
  //global key for navigator
  final navigatorKey = GlobalKey<NavigatorState>();
  di.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);
  di.registerSingleton<NavigationService>(
    NavigationServiceImpl(navigatorKey),
  );
  // page factories
  di.registerSingleton<Map<String, PageFactory>>(buildPageFactories());

  // Internacionalization instance
  final localizationService = LocalizationServiceImpl.instance;
  di.registerSingleton<LocalizationService>(localizationService);

  await localizationService.initialize();

  // http network config
  di.registerSingleton<Dio>(Dio());
  di.registerSingleton<DioHttpClient>(DioHttpClient(di.get<Dio>()));
  di.registerSingleton<ApiUrlConfigs>(ApiConfigRepositoryImpl());

  //mappers
  di.registerSingleton<UserDtoMapper>(UserDtoMapper());
  di.registerSingleton<UserEntityMapper>(UserEntityMapper());

  // repositories
  di.registerSingleton<UserRepositoryImpl>(UserRepositoryImpl(
      httpClient: di.get<DioHttpClient>(),
      apiConfig: di.get<ApiUrlConfigs>(),
      mapper: di.get<UserDtoMapper>(),
      userEntityMapper: di.get<UserEntityMapper>()));

  // Usecases
  di.registerFactory<GetUsersUseCase>(
      () => GetUsersUseCase(di.get<UserRepositoryImpl>()));

  // Presenters
  // di.registerFactory<UsersPresenter>(
  //   () => UsersRxPresenter(di.get<GetUsersUseCase>()),
  // );
  di.registerFactory<UsersPresenter>(
    () => UsersChangeNotifierPresenter(di.get<GetUsersUseCase>()),
  );

  di.registerFactory<LoginPresenter>(
    () => LoginChangeNotifierPresenter(
      di.get<NavigationService>(),
    ),
  );
}
