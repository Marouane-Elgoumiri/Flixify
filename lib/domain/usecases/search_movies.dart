import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/repositories/movie_repository.dart';

/// Parameters for searching movies.
class SearchMoviesParams {
  const SearchMoviesParams({required this.query});
  final String query;
}

/// Use case: Search movies by free-text query.
///
/// This is intentionally minimal — there is no validation, no caching,
/// no transformation. We could add debouncing / deduplication here later
/// as "business logic", but the point of a use case is to delegate
/// trivial work and provide a single named verb for the UI.
class SearchMoviesUseCase
    extends UseCase<List<Movie>, SearchMoviesParams> {
  SearchMoviesUseCase({required MovieRepository repository})
      : _repository = repository;

  final MovieRepository _repository;

  @override
  Future<Result<List<Movie>, Failure>> call(SearchMoviesParams params) {
    // Trim and ignore empty queries at the boundary so the controller
    // can stay simple.
    final query = params.query.trim();
    if (query.isEmpty) {
      return Future.value(const Success(<Movie>[]));
    }
    return _repository.searchMovies(query);
  }
}
