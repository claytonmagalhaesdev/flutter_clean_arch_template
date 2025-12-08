import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/core/config/themes/app_themes.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';
import 'package:flutter_clean_arch_template/core/navigation/page_factory.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final LocalizationService localizationService =
      ServiceLocator.get<LocalizationService>();

  final navigatorKey = ServiceLocator.get<GlobalKey<NavigatorState>>();
  final pageFactories = ServiceLocator.get<Map<String, PageFactory>>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      supportedLocales:
          localizationService.instanceLocalization.supportedLocales,
      localizationsDelegates:
          localizationService.instanceLocalization.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Template',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: pageFactories['/login']!(),
    );
  }
}
