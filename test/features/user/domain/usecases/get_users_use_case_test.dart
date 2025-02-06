import 'package:flutter_clean_arch_template/core/common/types/failures.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_repository.dart';
import 'package:flutter_clean_arch_template/features/user/domain/usecases/get_users_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUsersUseCase getUsersUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getUsersUseCase = GetUsersUseCase(mockUserRepository);
  });

  test('should get list of users from repository', () async {
    // arrange
    final users = [
      UserEntity(id: '1', name: 'Test User 1', email: '[email protected]'),
      UserEntity(id: '2', name: 'Test User 2', email: '[email protected]')
    ];

    when(() => mockUserRepository.getUsers())
        .thenAnswer((_) async => Result.ok(users));

    // act
    final result = await getUsersUseCase.execute();

    // assert
    expect(result, isA<Result<List<UserEntity>>>());
    expect(result.value, users);
    verify(() => mockUserRepository.getUsers()).called(1);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(() => mockUserRepository.getUsers())
        .thenAnswer((_) async => Result.error(NetworkFailure('Network error')));

    // act
    final result = await getUsersUseCase.execute();

    // assert
    expect(result, isA<Error<List<UserEntity>>>());
    expect((result as Error<List<UserEntity>>).error, isA<NetworkFailure>());
    verify(() => mockUserRepository.getUsers()).called(1);
  });
}
