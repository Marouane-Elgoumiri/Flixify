import 'package:get/get.dart';
import 'package:my_app/core/utils/result.dart';

/// Base class for all use cases in the application.
/// A use case represents a single piece of business logic.
/// It takes a parameter [P] (void if none) and returns a [Result] 
/// containing either a [Success] with data or an [Error] with a failure.
///
/// This pattern keeps your business logic independent of the UI and frameworks.
/// It's a key part of Clean Architecture.
///
/// Example: final result = await GetTrendingMoviesUseCase().execute();
abstract class UseCase<Type, Params> {
  Future<Result<Type, dynamic>> call(Params params);
}

/// A special class for use cases that don't require any parameters.
/// Dart doesn't support `Void` natively, so we use a simple type alias 
/// or a class like this.
class NoParams {
  const NoParams();
}
