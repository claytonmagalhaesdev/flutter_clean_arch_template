abstract class DependencyInjector {
  void registerSingleton<T extends Object>(T instance);
  void registerFactory<T extends Object>(T Function() factoryFunc);
  T get<T extends Object>();
}
