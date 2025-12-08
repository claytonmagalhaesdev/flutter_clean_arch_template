import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/di/get_it_dependency_injector.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';
import 'package:flutter_clean_arch_template/core/navigation/navigation_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() async {
    await GetIt.I.reset();
    final injector = GetItDependencyInjector();
    ServiceLocator.setup(injector);

    // Registrar mocks se necessário
    GetIt.I.registerSingleton<Map<String, Widget Function([Object?])>>({
      '/mock': ([args]) => const Placeholder(),
      // pode adicionar outras rotas se necessário
    });
  });

  testWidgets('should push the correct page when navigateTo is called',
      (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final navigationService = NavigationServiceImpl(navigatorKey);

    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/mock': (context) => const Placeholder(),
      },
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () => navigationService.navigateTo('/mock'),
            child: const Text('Go'),
          );
        },
      ),
    ));

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(find.byType(Placeholder), findsOneWidget);
  });
}
