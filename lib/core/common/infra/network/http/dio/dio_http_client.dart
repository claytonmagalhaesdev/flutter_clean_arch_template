import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/http_client.dart';
import 'package:flutter_clean_arch_template/core/common/failures.dart';
import 'package:flutter_clean_arch_template/core/common/types/types.dart';

//the implementation of the http client using dio
class DioHttpClient extends HttpClient {
  final Dio _dio;

  DioHttpClient(this._dio) {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  @override
  Future<dynamic> get(String url,
      {Json? queryParameters, Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(url,
          queryParameters: queryParameters, options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      if (e.error is Failure) {
        // Lançar a exceção genérica para a camada superior
        throw e.error ?? UnknownFailure('An unexpected error occurred.');
      } else {
        throw UnknownFailure('An unexpected error occurred.');
      }
    }
  }

  @override
  Future<dynamic> post(String url,
      {Json? data, Map<String, String>? headers}) async {
    try {
      final response =
          await _dio.post(url, data: data, options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw e.error ?? UnknownFailure('An unexpected error occurred.');
      } else {
        throw UnknownFailure('An unexpected error occurred.');
      }
    }
  }

  @override
  Future<Json> put(String url,
      {Json? data, Map<String, String>? headers}) async {
    try {
      final response =
          await _dio.put(url, data: data, options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw e.error ?? UnknownFailure('An unexpected error occurred.');
      } else {
        throw UnknownFailure('An unexpected error occurred.');
      }
    }
  }

  @override
  Future<void> delete(String url, {Map<String, String>? headers}) async {
    try {
      await _dio.delete(url, options: Options(headers: headers));
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw e.error ?? UnknownFailure('An unexpected error occurred.');
      } else {
        throw UnknownFailure('An unexpected error occurred.');
      }
    }
  }
}
