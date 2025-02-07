import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/app.dart';
import 'package:flutter_clean_arch_template/core/di/dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/di/get_it_dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/app_module.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  final DependencyInjector di = GetItDependencyInjector();
  AppInjector().setupDependencies(di);

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  runApp(App(di));
}
