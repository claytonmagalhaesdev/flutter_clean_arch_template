import 'package:flutter_clean_arch_template/core/navigation/navigation_service.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_presenter.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock for the NavigationService abstraction
class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late LoginChangeNotifierPresenter presenter;
  late MockNavigationService navigationService;

  setUp(() {
    navigationService = MockNavigationService();
    when(() => navigationService.navigateTo(any(),
            arguments: any(named: 'arguments')))
        .thenAnswer((_) async => Future.value());
    when(() => navigationService.goBack())
        .thenAnswer((_) async => Future.value());
    presenter = LoginChangeNotifierPresenter(navigationService);
  });

  test('should navigate to /users when loginCommand is executed', () async {
    // act
    await presenter.loginCommand.execute();

    // assert
    verify(() => navigationService.navigateTo('/users')).called(1);
  });

  test('should navigate to /login when logoutCommand is executed', () async {
    // act
    await presenter.logoutCommand.execute();

    // assert
    verify(() => navigationService.navigateTo('/login')).called(1);
  });

  test(
      'should emit LoginLoading and then LoginSuccess state when loginCommand is executed',
      () async {
    // arrange
    final emittedStates = <LoginState>[];
    final subscription = presenter.stateStream.listen(emittedStates.add);

    // act
    await presenter.loginCommand.execute();
    await Future.delayed(const Duration(
        milliseconds: 100)); // Wait a bit for the state to propagate

    // assert
    expect(emittedStates.first, isA<LoginLoading>());
    expect(emittedStates.last, isA<LoginSuccess>());
    await subscription.cancel();
  });
}
