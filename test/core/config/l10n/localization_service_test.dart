import 'package:flutter_clean_arch_template/core/config/l10n/app_translations.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_presenter.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLoginPresenter extends Mock implements LoginPresenter {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockLoginPresenter presenter;
  late MockLocalizationService localizationService;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    presenter = MockLoginPresenter();
    localizationService = MockLocalizationService();

    when(() => presenter.stateStream)
        .thenAnswer((_) => const Stream<LoginState>.empty());

    when(() => localizationService.getString(any())).thenReturn('Bem vindo');
  });

  testWidgets('show welcome text translate', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(
        presenter: presenter,
        localizationService: localizationService,
      ),
    ));

    expect(find.byKey(Key('welcome_text')), findsOneWidget);
    expect(find.text(localizationService.getString(AppTranslations.welcome)),
        findsWidgets);
  });

  testWidgets('getString translation returns correct en', (tester) async {
    final service = LocalizationServiceImpl.instance;
    await service.initialize();

    expect(service.getString('Welcome'), 'Welcome');
  });

  testWidgets('getString translation returns incorrect value for key',
      (tester) async {
    final service = LocalizationServiceImpl.instance;
    await service.initialize();
    expect(service.getString('key_test'), 'key_test');
  });
}
