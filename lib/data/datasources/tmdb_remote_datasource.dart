import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:my_app/core/constants/api_constants.dart';
import 'package:my_app/core/errors/exceptions.dart';
import 'package:my_app/data/models/movie_model.dart';
import 'package:my_app/core/config/tmdb_config.dart';
/// Remote data source that fetches movie data from the TMDb API.
///
/// SINGLE RESPONSIBILITY:
/// This class ONLY handles HTTP calls to TMDb. It does NOT:
/// - Know about the Domain layer (entities, repositories)
/// - Handle UI logic
/// - Manage state
///
/// It returns raw [MovieModel] objects. The mapping to [Movie] entities
/// happens in the repository layer.
class TmdbRemoteDataSource {
  TmdbRemoteDataSource({Dio? dio})
      : _dio = dio ?? _createDefaultDio();

  final Dio _dio;

  /// Factory method to create a Dio instance with default configuration.
  static Dio _createDefaultDio() {
    final options = BaseOptions(
      baseUrl: ApiConstants.tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        // Read credentials from .env via the centralized config class.
        'Authorization': 'Bearer ${TmdbConfig.accessToken}',
        'Accept': 'application/json',
      },
      queryParameters: {
        // Query-param version of the key (TMDb supports both methods)
        'api_key': TmdbConfig.apiKey,
      },
    );

    final dio = Dio(options);

    // In debug mode, add the Pretty Dio Logger to see API calls in console.
    // ignore: unnecessary_statements
    assert(() {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ));
      return true;
    }());

    return dio;
  }

  /// Fetches trending movies for the week.
  ///
  /// Throws [ServerException] if the API call fails.
  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final response = await _dio.get(ApiConstants.getTrendingMovies());
      final results = response.data['results'] as List<dynamic>;

      return results
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e, stackTrace) {
      developer.log('TMDb API Error: ${e.message}', stackTrace: stackTrace);
      throw ServerException(
        message: 'Failed to fetch trending movies: ${e.message}',
      );
    }
  }

  /// Fetches movie details by [id].
  Future<MovieModel> getMovieDetails(int id) async {
    try {
      final response =
          await _dio.get(ApiConstants.getMovieDetails(id));
      return MovieModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      developer.log('TMDb API Error: ${e.message}', stackTrace: stackTrace);
      throw ServerException(
        message: 'Failed to fetch movie details: ${e.message}',
      );
    }
  }

  /// Searches for movies matching [query].
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e, stackTrace) {
      developer.log('TMDb API Error: ${e.message}', stackTrace: stackTrace);
      throw ServerException(
        message: 'Failed to search movies: ${e.message}',
      );
    }
  }
}
