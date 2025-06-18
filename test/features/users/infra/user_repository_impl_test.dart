import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
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
    expect(result.isSuccess, isTrue);
    expect(result.value, hasLength(2));

    expect(result.value, [
      UserEntity(
        id: 1,
        name: 'Test User 1',
        email: '[email protected]',
        role: UserRole.regular,
        avatar: null,
        token: null,
        refreshToken: null,
      ),
      UserEntity(
        id: 2,
        name: 'Test User 2',
        email: '[email protected]',
        role: UserRole.regular,
        avatar: null,
        token: null,
        refreshToken: null,
      ),
    ]);

    verify(() => mockDio.get('$baseUrl/users')).called(1);
  });

  test('should return NetworkFailure when Dio call fails', () async {
    // 1) Mesma URL que o repositório chama
    final url = '$baseUrl/users';

    // 2) Stub devolvendo uma Future que Lança a DioException
    when(() => mockDio.get(url)).thenAnswer((_) async {
      throw DioException(
        requestOptions: RequestOptions(path: url),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          data: {'error': 'Not Found'},
          requestOptions: RequestOptions(path: url),
        ),
      );
    });

    // 3) Chama o repositório — agora o erro acontece _dentro_ da Future
    final result = await userRepository.getUsers();

    // 4) A extensão asResult() captura e converte em NetworkFailure
    expect(result.isError, isTrue);
    expect(result.exception, isA<NetworkFailure>());
    expect(result.errorMessage, 'Not Found');

    verify(() => mockDio.get(url)).called(1);
  });

  test('should return UnknownFailure when Dio call throws unknown error',
      () async {
    // arrange
    final url = '$baseUrl/users';

    when(() => mockDio.get(url)).thenAnswer((_) async {
      throw Exception('Unknown error');
    });

    // act
    final result = await userRepository.getUsers();

    // assert
    expect(result.isError, isTrue);
    expect(result.exception, isA<UnknownFailure>());
    expect(result.errorMessage, contains('Unknown error'));

    // verifica a chamada exata
    verify(() => mockDio.get(url)).called(1);
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

  test('should return Error when JSON is missing required fields', () async {
    final partialJson = [
      {"id": 1, "name": "Partial"}, // falta email
      {"id": 2, "email": "[email protected]"}, // falta name
    ];

    when(() => mockDio.get(any())).thenAnswer(
      (_) async => Response(
        data: partialJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: anyString()),
      ),
    );

    final result = await userRepository.getUsers();

    expect(result.isError, isTrue);
    expect(result.exception, isA<UnknownFailure>());
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
    // 1) a URL que o repositório realmente usa
    final url = '$baseUrl/users';

    // 2) stub do método para lançar a DioException dentro da Future
    when(() => mockDio.get(url)).thenAnswer((_) async {
      throw DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: url),
        error: NetworkFailure('Connection timed out'),
      );
    });

    // 3) chama o repositório
    final result = await userRepository.getUsers();

    // 4) valida que virou NetworkFailure com a mensagem correta
    expect(result.isError, isTrue);
    expect(result.exception, isA<NetworkFailure>());
    expect(result.errorMessage, 'Connection timed out');

    // 5) garante que mockDio.get() foi chamado com o URL exato
    verify(() => mockDio.get(url)).called(1);
  });

  test('should return generic NetworkFailure if DioException has no response',
      () async {
    // 1) mesma URL
    final url = '$baseUrl/users';

    // 2) stub levantando DioException sem response
    when(() => mockDio.get(url)).thenAnswer((_) async {
      throw DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: url),
        response: null,
      );
    });

    // 3) chama o repositório
    final result = await userRepository.getUsers();

    // 4) valida fallback para mensagem genérica
    expect(result.isError, isTrue);
    expect(result.exception, isA<NetworkFailure>());
    expect(result.errorMessage, contains('Um erro inesperado ocorreu.'));

    // 5) verificação do stub
    verify(() => mockDio.get(url)).called(1);
  });
}
