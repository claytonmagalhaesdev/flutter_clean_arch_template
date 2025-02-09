import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'language_state.dart';

class LanguageBloc extends Cubit<LanguageState> {
  final LocalizationService localizationService;
  late StreamSubscription<String> _localeSubscription;

  LanguageBloc(String initialLanguage)
      : localizationService = LocalizationService.instance,
        super(LanguageState(initialLanguage)) {
    // 🔥 Ouvindo mudanças do localeStream
    _localeSubscription =
        localizationService.localeStream.listen((languageCode) {
      emit(LanguageState(languageCode));
    });
  }

  void changeLanguage(String languageCode) {
    localizationService.changeLocale(languageCode);
  }

  @override
  Future<void> close() {
    _localeSubscription.cancel();
    return super.close();
  }
}
