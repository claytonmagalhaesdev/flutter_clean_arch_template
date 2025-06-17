// domain/exceptions/failures.dart
abstract class Failure implements Exception {
  String get message;
  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  @override
  final String message;
  NetworkFailure(this.message);
}

class ServerFailure extends Failure {
  @override
  final String message;
  ServerFailure(this.message);
}

class UnknownFailure extends Failure {
  @override
  final String message;
  UnknownFailure(this.message);
}
