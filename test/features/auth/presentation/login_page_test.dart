import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/command.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/core/di/get_it_dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_page.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_presenter.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Mock for the presenter
class MockLoginPresenter extends Mock implements LoginPresenter {}

class MockLocalizationService extends Mock implements LocalizationService {}

class MockCommand extends Mock implements Command0<void> {}

void main() {
  late MockCommand mockLoginCommand;

  late MockLoginPresenter presenter;
  late MockLocalizationService localizationService;

  setUp(() async {
    await GetIt.I.reset();
    presenter = MockLoginPresenter();
    localizationService = MockLocalizationService();
    mockLoginCommand = MockCommand();

    final injector = GetItDependencyInjector();
    ServiceLocator.setup(injector);
    injector.registerSingleton<LocalizationService>(localizationService);

    when(() => localizationService.getString(any(that: isA<String>())))
        .thenReturn('dummy');

    when(() => presenter.loginCommand).thenReturn(mockLoginCommand);
    when(() => mockLoginCommand.execute()).thenAnswer((_) async {});
  });

  testWidgets(
      'should trigger loginCommand.execute when "login_button" button is tapped',
      (tester) async {
    when(() => presenter.stateStream)
        .thenAnswer((_) => const Stream<LoginState>.empty());

    await tester.pumpWidget(MaterialApp(
      home: LoginPage(
          presenter: presenter, localizationService: localizationService),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump();

    verify(() => mockLoginCommand.execute()).called(1);
  });

  testWidgets(
    'should display CircularProgressIndicator when state is LoginLoading',
    (tester) async {
      when(() => presenter.stateStream)
          .thenAnswer((_) => Stream.value(LoginLoading()));

      await tester.pumpWidget(MaterialApp(
        home: LoginPage(
            presenter: presenter, localizationService: localizationService),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}
