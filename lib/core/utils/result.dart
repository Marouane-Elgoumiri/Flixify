/// A simple Result type for type-safe error handling.
///
/// Instead of throwing exceptions that can crash the app,
/// we return a [Result] which is either [Success] or [Error].
/// This makes error handling explicit and predictable.
///
/// COMBINATOR API:
/// Use [when] to pattern-match on the result, eliminating the need
/// for verbose `is Success` / `is Error` checks at every call site.
sealed class Result<S, E> {
  const Result();

  /// Pattern-match on this result.
  /// - [success] is called with the data if this is a [Success]
  /// - [error]   is called with the error if this is an [Error]
  R when<R>({
    required R Function(S data) success,
    required R Function(E error) error,
  }) {
    final self = this;
    if (self is Success<S, E>) return success(self.data);
    if (self is Error<S, E>)   return error(self.error);
    throw StateError('Unknown Result type: $self');
  }

  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<S, E>;

  /// Returns true if this is an [Error].
  bool get isError => this is Error<S, E>;

  /// Returns the success data, or null if this is an error.
  /// Useful in tests or when accessing optional success data.
  S? get dataOrNull {
    final self = this;
    if (self is Success<S, E>) return self.data;
    return null;
  }

  /// Returns the error, or null if this is a success.
  E? get errorOrNull {
    final self = this;
    if (self is Error<S, E>) return self.error;
    return null;
  }
}

final class Success<S, E> extends Result<S, E> {
  const Success(this.data);
  final S data;
}

final class Error<S, E> extends Result<S, E> {
  const Error(this.error);
  final E error;
}
