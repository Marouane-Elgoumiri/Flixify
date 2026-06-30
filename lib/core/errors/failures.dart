/// The [Failure] class represents a business-logic level failure.
/// It is used in the Domain and Presentation layers.
/// This allows us to return an error in a type-safe way (using Either)
/// instead of throwing exceptions across layers.
class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => 'Failure(message: $message)';
}

class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server failure'}) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache failure'}) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({String message = 'Invalid input'}) : super(message);
}
