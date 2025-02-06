import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/app.dart';
import 'package:flutter_clean_arch_template/core/di/dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/di/get_it_dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/factories/app_module.dart';

void main() {
  final DependencyInjector di = GetItDependencyInjector();
  setupDependencies(di);
  runApp(App(di));
}
