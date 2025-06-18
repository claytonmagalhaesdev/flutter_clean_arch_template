//widget tests
// test/features/users/presentation/users_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/command.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_page.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_state.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/user_model.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
import 'dart:async';

class MockUsersPresenter extends Mock implements UsersPresenter {}

void main() {
  late MockUsersPresenter mockPresenter;
  late StreamController<UsersState> controller;

  setUp(() {
    mockPresenter = MockUsersPresenter();
    controller = StreamController<UsersState>.broadcast();
    when(() => mockPresenter.stateStream).thenAnswer((_) => controller.stream);
    when(() => mockPresenter.loadUsersCommand).thenReturn(
      Command0<void>(
        () async {
          return Result.ok(null);
        },
      ),
    );
  });

  tearDown(() {
    controller.close();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UsersPage(presenter: mockPresenter),
      ),
    );
    // initState
    verify(() => mockPresenter.loadUsersCommand.execute()).called(1);
  }

  testWidgets('show spinner when loading', (tester) async {
    await pumpPage(tester);
    // emit Loading
    controller.add(const UsersLoading());
    await tester.pump(); // rebuild

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('show list when has data', (tester) async {
    await pumpPage(tester);

    // prepare UserModel de test
    final u = UserModel(
      displayName: 'JOHN',
      emailMasked: 'j***@x.com',
      avatarUrl: null,
      role: UserRole.admin,
    );

    // emit state w data
    controller.add(UsersData(
      UsersViewModel.fromModels([u]),
    ));
    await tester.pump();

    // deve aparecer um ListTile com título "JOHN"
    expect(find.text('JOHN'), findsOneWidget);
    // seção Admin
    expect(find.text('Administradores'), findsOneWidget);
  });

  testWidgets('show error button reload', (tester) async {
    await pumpPage(tester);

    controller.add(const UsersError('Erro ao carregar usuários'));
    await tester.pump();

    expect(find.text('Erro ao carregar usuários'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);

    await tester.tap(find.text('Recarregar'));
    await tester.pump();

    verify(() => mockPresenter.loadUsersCommand.execute())
        .called((1));
  });
}
