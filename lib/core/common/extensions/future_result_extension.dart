import 'package:dio/dio.dart';
import '../types/result.dart';
import '../types/failures.dart';

extension FutureResultX<T> on Future<T> {
  Future<Result<T>> asResult() async {
    try {
      return Result.ok(await this);
    } on DioException catch (e) {
      final underlying = e.error;
      if (underlying is Failure) return Result.error(underlying);
      final msg = e.response?.data['error']?.toString() 
                  ?? 'Um erro inesperado ocorreu.';
      return Result.error(NetworkFailure(msg));
    } catch (e) {
      return Result.error(UnknownFailure(e.toString()));
    }
  }
}
