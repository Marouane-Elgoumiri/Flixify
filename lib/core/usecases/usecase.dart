/// Base class for all use cases in the application.
/// A use case represents a single piece of business logic.
/// It takes a parameter [DataType] (void if none) and returns a [DataType] 
/// containing either data or an error.
///
/// This pattern keeps your business logic independent of the UI and frameworks.
/// It's a key part of Clean Architecture.
///
/// Example: final result = await GetTrendingMoviesUseCase().execute();
abstract class UseCase<DataType, Params> {
  Future<DataType> call(Params params);
}

/// A special class for use cases that don't require any parameters.
/// Dart doesn't support `Void` natively, so we use a simple type alias 
/// or a class like this.
class NoParams {
  const NoParams();
}
