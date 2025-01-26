import 'package:flutter_clean_arch_template/core/common/types/types.dart';

//the interface for the http client (dio or other package or implementation)
abstract class HttpClient {
  Future<dynamic> get(
    String url, {
    Json? queryParameters,
    Map<String, String>? headers,
  });

  Future<dynamic> post(
    String url, {
    Json? data,
    Map<String, String>? headers,
  });

  Future<dynamic> put(
    String url, {
    Json? data,
    Map<String, String>? headers,
  });

  Future<void> delete(
    String url, {
    Map<String, String>? headers,
  });
}
