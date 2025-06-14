import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/types/failures.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/api_url_configs.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/dio/dio_http_client.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_dto_mapper.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_entity_mapper.dart';
import 'package:flutter_clean_arch_template/features/users/infra/user_repository_impl.dart';
import 'package:flutter_clean_arch_template/features/users/domain/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fakes.dart';

class MockDio extends Mock implements DioHttpClient {}

void main() {
  late UserRepositoryImpl userRepository;
  late MockDio mockDio;
  late ApiUrlConfigs apiUrlConfigs;
  late String baseUrl;
  late UserDtoMapper userDtoMapper;
  late UserEntityMapper userEntityMapper;

  setUp(() {
    mockDio = MockDio();
    apiUrlConfigs = ApiConfigRepositoryImpl();
    baseUrl = apiUrlConfigs.getBaseUrl('jsonplaceholder');
    userDtoMapper = UserDtoMapper();
    userEntityMapper = UserEntityMapper();
    userRepository = UserRepositoryImpl(
        httpClient: mockDio,
        apiConfig: apiUrlConfigs,
        mapper: userDtoMapper,
        userEntityMapper: userEntityMapper);
  });

  test('should return list of users when Dio call is successful', () async {
    // arrange
    final responseData = [
      {"id": 1, "name": "Test User 1", "email": "[email protected]"},
      {"id": 2, "name": "Test User 2", "email": "[email protected]"}
    ];

    //interceptor fake response
    when(() => mockDio.get(any())).thenAnswer(
      (_) async => Response(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: anyString()),
      ),
    );

    // act
    final result = await userRepository.getUsers();

    // assert
    expect(result, isA<Result<List<UserEntity>>>());
    expect(result.value, isNotNull);
    expect(
      result.value,
      [
        UserEntity(id: 1, name: 'Test User 1', email: '[email protected]'),
        UserEntity(id: 2, name: 'Test User 2', email: '[email protected]'),
      ],
    );
    verify(() => mockDio.get('$baseUrl/users')).called(1);
  });

  test('should return NetworkFailure when Dio call fails', () async {
    // arrange
    when(() => mockDio.get(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: anyString()),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          data: {'error': 'Not Found'},
          requestOptions: RequestOptions(
            path: anyString(),
          ),
        ),
      ),
    );

    // act
    final result = await userRepository.getUsers();

    // assert
    expect(result, isA<Error<List<UserEntity>>>());
    expect((result as Error<List<UserEntity>>).error, isA<NetworkFailure>());
    verify(() => mockDio.get('https://jsonplaceholder.typicode.com/users'))
        .called(1);
  });

  test('should return UnknownFailure when Dio call throws unknown error',
      () async {
    // arrange
    when(() => mockDio.get(any())).thenThrow(Exception('Unknown error'));

    // act
    final result = await userRepository.getUsers();

    // assert
    expect(result, isA<Error<List<UserEntity>>>());
    expect((result as Error<List<UserEntity>>).error, isA<UnknownFailure>());
    verify(() => mockDio.get('https://jsonplaceholder.typicode.com/users'))
        .called(1);
  });

  test('should return empty list if API returns empty array', () async {
    when(() => mockDio.get(any())).thenAnswer(
      (_) async => Response(
        data: [],
        statusCode: 200,
        requestOptions: RequestOptions(path: anyString()),
      ),
    );

    final result = await userRepository.getUsers();

    expect(result, isA<Result<List<UserEntity>>>());
    expect(result.value, isEmpty);
    verify(() => mockDio.get('$baseUrl/users')).called(1);
  });

  test('should handle partial user data gracefully', () async {
    final partialJson = [
      {"id": 1, "name": "Partial"}, // missing email
      {"id": 2, "email": "[email protected]"}, // missing name
    ];

    when(() => mockDio.get(any())).thenAnswer(
      (_) async => Response(
        data: partialJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: anyString()),
      ),
    );

    final result = await userRepository.getUsers();

    // Dependendo do comportamento do seu UserDtoMapper,
    // isso pode lançar erro, ou retornar entidades parciais
    switch (result) {
      case Ok(value: final users):
        expect(users.length, 2);
        expect(users.first.name, 'Alice');
        break;
      case Error(error: final e):
        fail('Expected Ok, but got Error: $e');
    }
  });

  test('should handle incomplete JSON gracefully', () async {
    // arrange
    final partialJson = [
      {"id": 1, "name": "Partial User"}, // falta email
      {"id": 2, "email": "[email protected]"}, // falta name
    ];

    when(() => mockDio.get(any())).thenAnswer(
      (_) async => Response(
        data: partialJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: anyString()),
      ),
    );

    // act
    final result = await userRepository.getUsers();

    // assert
    expect(result, isA<Error<List<UserEntity>>>());
    expect((result as Error).error, isA<Exception>()); // comportamento esperado
  });

  test('should return empty list if API returns empty array', () async {
    when(() => mockDio.get(any())).thenAnswer(
      (_) async => Response(
        data: [],
        statusCode: 200,
        requestOptions: RequestOptions(path: anyString()),
      ),
    );

    final result = await userRepository.getUsers();

    expect(result, isA<Result<List<UserEntity>>>());
    expect(result.value, isEmpty);
  });

  test('should return NetworkFailure on Dio connection timeout', () async {
    when(() => mockDio.get(any())).thenThrow(
      DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: anyString()),
        error: 'Connection timed out',
      ),
    );

    final result = await userRepository.getUsers();

    expect(result, isA<Error<List<UserEntity>>>());
    expect((result as Error).error, isA<NetworkFailure>());
    expect(result.errorMessage, contains('Connection timed out'));
  });

  test('should return generic NetworkFailure if DioException has no response',
      () async {
    when(() => mockDio.get(any())).thenThrow(
      DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: anyString()),
        response: null, // ← resposta nula
      ),
    );

    final result = await userRepository.getUsers();

    expect(result, isA<Error<List<UserEntity>>>());
    expect((result as Error).error, isA<NetworkFailure>());
    expect(result.errorMessage, contains('An unexpected error occurred'));
  });
}
