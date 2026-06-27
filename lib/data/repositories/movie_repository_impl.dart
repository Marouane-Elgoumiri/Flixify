import 'package:my_app/core/errors/exceptions.dart';
import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/data/datasources/tmdb_remote_datasource.dart';
import 'package:my_app/data/models/movie_model.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/repositories/movie_repository.dart';

/// Concrete implementation of [MovieRepository] interface.
///
/// This class lives in the Data layer. It implements the abstract
/// contract defined in the Domain layer (Dependency Inversion).
///
/// It takes a [TmdbRemoteDataSource] via the constructor (DI).
/// This allows us to swap the data source (e.g., for testing) without
/// changing this class.
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({required TmdbRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final TmdbRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Movie>, Failure>> getTrendingMovies() async {
    try {
      // Fetch raw models from the data source.
      final List<MovieModel> models =
          await _remoteDataSource.getTrendingMovies();

      // Map models to domain entities.
      // This enforces business rules (e.g., non-null titles).
      final List<Movie> movies =
          models.map((model) => model.toEntity()).toList();

      return Success(movies);
    } on ServerException catch (e) {
      // Convert data layer exception to domain layer failure.
      return Error(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Result<Movie, Failure>> getMovieDetails(int id) async {
    try {
      final MovieModel model = await _remoteDataSource.getMovieDetails(id);
      return Success(model.toEntity());
    } on ServerException catch (e) {
      return Error(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Result<List<Movie>, Failure>> searchMovies(String query) async {
    try {
      final List<MovieModel> models =
          await _remoteDataSource.searchMovies(query);
      final List<Movie> movies =
          models.map((model) => model.toEntity()).toList();
      return Success(movies);
    } on ServerException catch (e) {
      return Error(ServerFailure(message: e.message));
    }
  }
}
