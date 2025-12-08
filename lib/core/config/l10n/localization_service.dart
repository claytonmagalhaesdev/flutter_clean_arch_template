import 'dart:async';
import 'dart:ui';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_translations.dart';

//interface for localization service
abstract class LocalizationService {
  Future<void> initialize();
  String getString(String key);
  FlutterLocalization get instanceLocalization;
}

//implementation of localization service
class LocalizationServiceImpl implements LocalizationService {
  late Map<String, String> _translations;

  static final LocalizationServiceImpl instance = LocalizationServiceImpl._();

  final FlutterLocalization _localization = FlutterLocalization.instance;

  LocalizationServiceImpl._();

  @override
  Future<void> initialize() async {
    await _localization.ensureInitialized();
    _initLocalization();
    _loadTranslations();
  }

  void _initLocalization() {
    final Locale systemLocale = PlatformDispatcher.instance.locale;

    _localization.init(
      mapLocales: [
        MapLocale(EnumLanguage.english.code, AppTranslations.en),
        MapLocale(EnumLanguage.portuguese.code, AppTranslations.pt),
        MapLocale(EnumLanguage.japanese.code, AppTranslations.ja),
      ],
      initLanguageCode: systemLocale.languageCode,
    );
  }

  void _loadTranslations() {
    final currentLocale = _localization.currentLocale?.languageCode ?? 'en';
    _translations = _getTranslationsForLocale(currentLocale);
  }

  Map<String, String> _getTranslationsForLocale(String languageCode) {
    switch (languageCode) {
      case 'pt':
        return Map<String, String>.from(AppTranslations.pt);
      case 'ja':
        return Map<String, String>.from(AppTranslations.ja);
      default:
        return Map<String, String>.from(AppTranslations.en);
    }
  }

  @override
  String getString(String key) {
    return _translations[key] ?? key;
  }

  @override
  FlutterLocalization get instanceLocalization => _localization;
}
