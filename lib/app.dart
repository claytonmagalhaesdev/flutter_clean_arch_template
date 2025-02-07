import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/common/services/init_localization_service.dart';
import 'package:flutter_clean_arch_template/core/di/dependency_injector.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/user_page.dart';

class App extends StatefulWidget {
  final DependencyInjector di;

  const App(this.di, {super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final localizationService = InitLocalizationService.instance;

  @override
  void initState() {
    localizationService.call();
    localizationService.getLocalization.onTranslatedLanguage =
        (Locale? locale) {
      setState(() {});
    };
    super.initState();
  }

  @override
  void dispose() {
    localizationService.getLocalization.onTranslatedLanguage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Template',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: widget.di.get<UserPage>(),
    );
  }
}
