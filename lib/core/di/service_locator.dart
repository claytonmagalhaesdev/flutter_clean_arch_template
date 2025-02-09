import 'package:flutter_clean_arch_template/core/di/dependency_injector.dart';

class ServiceLocator {
  static late DependencyInjector _injector;

  // Método para configurar o injetor
  static void setup(DependencyInjector injector) {
    _injector = injector;
  }

  // Método para obter a dependência registrada
  static T get<T extends Object>() {
    return _injector.get<T>();
  }
}
