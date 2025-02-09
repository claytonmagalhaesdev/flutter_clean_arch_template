import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/app.dart';
import 'package:flutter_clean_arch_template/core/di/get_it_dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';
import 'package:flutter_clean_arch_template/core/di/setup_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final injector = GetItDependencyInjector();
  setupDependencies(injector);

  ServiceLocator.setup(injector);

  runApp(App());
}
