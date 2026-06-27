import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/utils/result.dart';

/// Base class for all use cases in the application.
///
/// Each use case represents a single, well-defined business action.
/// It takes [Params] and returns a [Result] (either Success or Error).
///
/// Why wrap the return in [Result]?
/// - It makes error handling EXPLICIT.
/// - Callers MUST decide what to do with the Error case, instead of relying
///   on try/catch or exceptions propagating unpredictably.
/// - The error type [Failure] is a business-level failure, not just any
///   exception. This means our domain decides what an "error" means.
///
/// Example:
/// ```
/// final result = await getTrendingMoviesUseCase.call(const NoParams());
/// result.when(
///   success: (movies) => print('Got ${movies.length} movies'),
///   error: (failure) => print('Failed: ${failure.message}'),
/// );
/// ```
abstract class UseCase<TData, TParams> {
  Future<Result<TData, Failure>> call(TParams params);
}

/// A special class for use cases that don't require any parameters.
/// Dart doesn't support `Void` natively, so we use a marker class.
class NoParams {
  const NoParams();
}
