import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/types/failures.dart';

//the interceptor to handle the errors using dio
class DioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkFailure('Connection timeout occurred.'),
        ),
      );
    } else if (err.response?.statusCode == 500) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ServerFailure('Internal server error.'),
        ),
      );
    } else if (err.response?.statusCode == 404) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ServerFailure('Resource not found.'),
        ),
      );
    } else {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: UnknownFailure('An unknown error occurred.'),
        ),
      );
    }
  }
}
