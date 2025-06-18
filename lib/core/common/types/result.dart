sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;
  const factory Result.error(Exception error) = Error._;
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  /// Returned value in result
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Returned error in result
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Ok<T>;
  bool get isError => this is Error<T>;

  T? get value => (this is Ok<T>) ? (this as Ok<T>).value : null;

  String? get errorMessage =>
      (this is Error<T>) ? (this as Error<T>).error.toString() : null;

  Exception? get exception =>
      this is Error<T> ? (this as Error<T>).error : null;
}
