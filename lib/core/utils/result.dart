/// A simple Result type for type-safe error handling.
/// Instead of throwing exceptions that can crash the app,
/// we return a [Result] which can be either [Success] or [Error].
/// This makes error handling explicit and predictable.
sealed class Result<S, E> {
  const Result();
}

final class Success<S, E> extends Result<S, E> {
  const Success(this.data);
  final S data;
}

final class Error<S, E> extends Result<S, E> {
  const Error(this.error);
  final E error;
}
