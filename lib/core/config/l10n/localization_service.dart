import 'dart:async';
import 'dart:ui';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_translations.dart';

class LocalizationService {
  late Map<String, String> _translations;

  static final LocalizationService instance = LocalizationService._();

  final FlutterLocalization _localization = FlutterLocalization.instance;

  // StreamController para notificar mudanças de idioma
  final StreamController<String> _localeController =
      StreamController.broadcast();

  Stream<String> get localeStream => _localeController.stream;

  LocalizationService._();

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

  String getString(String key) {
    return _translations[key] ?? key;
  }

  // ✅ Agora notifica o StreamController ao mudar o idioma
  void changeLocale(String languageCode) {
    _localization.translate(languageCode);
    _translations = _getTranslationsForLocale(languageCode);
    _localeController.add(languageCode); // 🔥 Notifica ouvintes sobre a mudança
  }

  String get currentLocale => _localization.currentLocale?.languageCode ?? 'en';

  FlutterLocalization get instanceLocalization => _localization;

  void dispose() {
    _localeController.close();
  }
}
