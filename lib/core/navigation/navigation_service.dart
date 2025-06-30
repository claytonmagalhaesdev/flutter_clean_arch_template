//interface
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';
import 'package:flutter_clean_arch_template/core/navigation/page_factory.dart';

abstract class NavigationService {
  Future<void> navigateTo(String routeName, {Object? arguments});
  void goBack();
}

//implementation with GlobalKey and Navigator
class NavigationServiceImpl implements NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationServiceImpl(this.navigatorKey);

  @override
  Future<void> navigateTo(String routeName, {Object? arguments}) {
    final pageFactories = ServiceLocator.get<Map<String, PageFactory>>();
    final pageFactory = pageFactories[routeName];
    if (pageFactory == null) {
      throw Exception('PageFactory não registrada para $routeName');
    }
    final page = pageFactory(arguments);
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  void goBack() => navigatorKey.currentState!.pop();
}
