// test/features/users/presentation/users_change_notifier_presenter_test.dart

import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/users/domain/usecases/get_users_use_case.dart';
import 'package:flutter_clean_arch_template/features/users/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_cn_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_state.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

void main() {
  late MockGetUsersUseCase mockUseCase;
  late UsersChangeNotifierPresenter presenter;

  setUp(() {
    mockUseCase = MockGetUsersUseCase();
    presenter = UsersChangeNotifierPresenter(mockUseCase);
  });

  tearDown(() {
    presenter.dispose();
  });

  test('emit Loading and Data user list when use case return success',
      () async {
    final entityList = <UserEntity>[
      UserEntity(
        id: 1,
        name: 'Alice',
        email: 'alice@example.com',
        role: UserRole.admin,
        avatar: null,
        token: '',
        refreshToken: '',
      ),
      UserEntity(id: 2, name: 'Bob', email: 'bob@bob.com')
    ];

    //stub of use case
    when(() => mockUseCase.execute())
        .thenAnswer((_) async => Result.ok(entityList));

    expectLater(
      presenter.stateStream,
      emitsInOrder([
        isA<UsersLoading>(),
        isA<UsersData>().having(
          (s) => (s).viewModel.admins.length,
          'admins.length',
          equals(1),
        ),
      ]),
    );

    await presenter.loadUsersCommand.execute();
  });

  test('emit Loading and Error when use case fail', () async {
    when(() => mockUseCase.execute())
        .thenAnswer((_) async => Result.error(Exception('falha!')));

    // await Loading → Error(...)
    expectLater(
      presenter.stateStream,
      emitsInOrder([
        isA<UsersLoading>(),
        predicate<UsersError>(
          (state) => state.message.contains('falha!'),
          'UsersError com mensagem de falha',
        ),
      ]),
    );

    await presenter.loadUsersCommand.execute();
  });
}
