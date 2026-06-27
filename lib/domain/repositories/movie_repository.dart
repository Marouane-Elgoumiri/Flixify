import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/movie.dart';

/// Abstract contract for movie-related data operations.
///
/// This interface lives in the Domain layer because the Domain layer
/// should NOT depend on the Data layer (Dependency Inversion Principle).
/// The Data layer will provide a concrete implementation.
///
/// WHY AN INTERFACE?
/// - Allows us to swap implementations (e.g., mock for testing, or a
///   different API provider) without changing the Domain or Presentation layers.
/// - Makes testing easy: we can mock this interface using mockito.
abstract class MovieRepository {
  /// Fetches a list of trending movies from the data source.
  ///
  /// Returns a [Result] that is either:
  /// - [Success] containing a [List<Movie>]
  /// - [Error] containing a [Failure]
  Future<Result<List<Movie>, Failure>> getTrendingMovies();

  /// Fetches a single movie's details by its [id].
  Future<Result<Movie, Failure>> getMovieDetails(int id);

  /// Searches for movies matching the given [query].
  Future<Result<List<Movie>, Failure>> searchMovies(String query);
}
