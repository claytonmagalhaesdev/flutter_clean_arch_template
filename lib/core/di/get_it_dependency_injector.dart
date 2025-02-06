import 'package:get_it/get_it.dart';
import 'dependency_injector.dart';

class GetItDependencyInjector implements DependencyInjector {
  final GetIt _getIt = GetIt.instance;

  @override
  void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  @override
  void registerFactory<T extends Object>(T Function() factoryFunc) {
    _getIt.registerFactory<T>(factoryFunc);
  }

  @override
  T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
