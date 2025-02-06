import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/failures.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/api_url_configs.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/dio/dio_http_client.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_repository_impl.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fakes.dart';

class MockDio extends Mock implements DioHttpClient {}

void main() {
  late UserRepositoryImpl userRepository;
  late MockDio mockDio;
  late ApiUrlConfigs apiUrlConfigs;
  late String baseUrl;

  setUp(() {
    mockDio = MockDio();
    apiUrlConfigs = ApiConfigRepositoryImpl();
    baseUrl = apiUrlConfigs.getBaseUrl('jsonplaceholder');
    userRepository =
        UserRepositoryImpl(httpClient: mockDio, apiConfig: apiUrlConfigs);
  });

  test('should return list of users when Dio call is successful', () async {
    // arrange
    final responseData = [
      {"id": "1", "name": "Test User 1", "email": "[email protected]"},
      {"id": "2", "name": "Test User 2", "email": "[email protected]"}
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
        UserEntity(id: '1', name: 'Test User 1', email: '[email protected]'),
        UserEntity(id: '2', name: 'Test User 2', email: '[email protected]'),
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
}
