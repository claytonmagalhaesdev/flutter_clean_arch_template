import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/common/infra/network/http/http_client.dart';
import 'package:flutter_clean_arch_template/core/common/types/failures.dart';
import 'package:flutter_clean_arch_template/core/common/types/types.dart';

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
      {Json? queryParameters, Map<String, String>? headers}) {
    return _handleRequest(() => _dio.get(url,
        queryParameters: queryParameters, options: Options(headers: headers)));
  }

  @override
  Future<Json> post(String url, {Json? data, Map<String, String>? headers}) {
    return _handleRequest(
        () => _dio.post(url, data: data, options: Options(headers: headers)));
  }

  @override
  Future<Json> put(String url, {Json? data, Map<String, String>? headers}) {
    return _handleRequest(
        () => _dio.put(url, data: data, options: Options(headers: headers)));
  }

  @override
  Future<void> delete(String url, {Map<String, String>? headers}) async {
    await _handleRequest(
        () => _dio.delete(url, options: Options(headers: headers)));
  }

  Future<T> _handleRequest<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return response as T;
    } on DioException catch (e) {
      throw e.error is Failure
          ? e.error!
          : UnknownFailure('An unexpected error occurred.');
    }
  }
}
