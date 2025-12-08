import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_page.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_presenter.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/core/di/get_it_dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';

import 'package:flutter_clean_arch_template/core/navigation/page_factory.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginPresenter extends Mock implements LoginPresenter {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  setUp(() {
    final injector = GetItDependencyInjector();
    ServiceLocator.setup(injector);

    // Register mocks
    injector.registerSingleton<LoginPresenter>(MockLoginPresenter());
    injector.registerSingleton<LocalizationService>(MockLocalizationService());
  });

  test('PageFactories retorna LoginPage', () {
    final factories = buildPageFactories();
    final page = factories['/login']?.call();
    expect(page, isA<LoginPage>());

    final loginPage = page as LoginPage;
    expect(loginPage.localizationService, isA<LocalizationService>());
    expect(loginPage.presenter, isA<LoginPresenter>());
  });
}
