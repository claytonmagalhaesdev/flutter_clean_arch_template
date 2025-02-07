import 'dart:ui';

import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_locale.dart';
import 'package:flutter_localization/flutter_localization.dart';

class InitLocalizationService {
  InitLocalizationService._();

  static final instance = InitLocalizationService._();

  final localization = FlutterLocalization.instance;

  FlutterLocalization get getLocalization => localization;

  void call() {
    final Locale systemLocale = PlatformDispatcher.instance.locale;

    localization.init(
      mapLocales: [
        MapLocale(EnumLanguage.english.code, AppLocale.en),
        MapLocale(EnumLanguage.portuguese.code, AppLocale.pt),
        MapLocale(EnumLanguage.japanese.code, AppLocale.ja),
      ],
      //initialize the language code according to the system
      initLanguageCode: systemLocale.languageCode,
    );
  }
}
