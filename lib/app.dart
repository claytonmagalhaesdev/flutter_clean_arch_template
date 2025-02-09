import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/core/common/presentation/bloc/language_bloc.dart';
import 'package:flutter_clean_arch_template/core/common/presentation/bloc/language_state.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/pages/login_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final LocalizationService localizationService =
      ServiceLocator.get<LocalizationService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LanguageBloc(ServiceLocator.get<LocalizationService>().currentLocale),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            locale: Locale(state.currentLanguage),
            supportedLocales:
                localizationService.instanceLocalization.supportedLocales,
            localizationsDelegates:
                localizationService.instanceLocalization.localizationsDelegates,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Template',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: LoginPage(),
          );
        },
      ),
    );
  }
}
