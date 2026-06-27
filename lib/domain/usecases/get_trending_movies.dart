import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/repositories/movie_repository.dart';

/// Use case: Get Trending Movies
///
/// This class represents the single responsibility of fetching trending movies.
/// It has NO knowledge of the UI, HTTP, or databases. It only knows about
/// the [MovieRepository] contract and returns a [Result].
///
/// BENEFITS OF USE CASES:
/// - Testable in isolation (just mock the repository)
/// - Reusable across different features (Home, Search, etc.)
/// - Swappable (we can replace this with a different trending algorithm)
class GetTrendingMoviesUseCase extends UseCase<List<Movie>, NoParams> {
  /// Repository injected via constructor (Dependency Inversion).
  final MovieRepository _repository;

  GetTrendingMoviesUseCase({required MovieRepository repository})
      : _repository = repository;

  @override
  Future<Result<List<Movie>, Failure>> call(NoParams params) {
    // The use case is a thin wrapper around the repository.
    // In more complex scenarios, we might apply business logic here
    // like filtering, sorting, or caching policies.
    return _repository.getTrendingMovies();
  }
}
