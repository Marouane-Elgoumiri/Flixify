import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/api_constants.dart';
import 'package:my_app/core/config/tmdb_config.dart';
import 'package:my_app/data/datasources/tmdb_remote_datasource.dart';
import 'package:my_app/data/repositories/movie_repository_impl.dart';
import 'package:my_app/domain/repositories/movie_repository.dart';
import 'package:my_app/domain/usecases/get_trending_movies.dart';
import 'package:my_app/domain/usecases/search_movies.dart';
import 'package:my_app/presentation/controllers/home_controller.dart';
import 'package:my_app/presentation/controllers/search_controller.dart';
import 'package:my_app/presentation/controllers/watchlist_controller.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';
/// Sets up all dependencies for the application using GetX.
///
/// This is where we wire together the layers of Clean Architecture:
/// 1. Data Sources (Dio + TmdbRemoteDataSource)
/// 2. Repositories (MovieRepositoryImpl)
/// 3. Use Cases (GetTrendingMoviesUseCase)
///
/// GetX's dependency injection makes this easy with Get.put(), Get.lazyPut(),
/// and Get.find(). These are like a service locator pattern.
///
/// TEACHING: We separate dependency CREATION from dependency USAGE.
/// This file does the creation. Widgets and controllers do the usage.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ignore: unnecessary_statements
    final prettyLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    );

    // --- Data Layer ---
    // Read TMDB credentials from the .env file via TmdbConfig.
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Authorization': 'Bearer ${TmdbConfig.accessToken}',
        'Accept': 'application/json',
      },
      queryParameters: {
        'api_key': TmdbConfig.apiKey,
      },
    ));

    // Only add the logger in debug mode
    assert(() {
      dio.interceptors.add(prettyLogger);
      return true;
    }());

    // Register Dio with GetX so we can find it anywhere with Get.find<Dio>()
    Get.put(dio);

    // Register the remote data source. It needs Dio (injected via Get.find).
    Get.put(TmdbRemoteDataSource(dio: dio));

    // --- Domain Layer (bridged via Repository) ---
    // Register the repository. GetX automatically injects the data source.
    Get.put<MovieRepository>(
      MovieRepositoryImpl(remoteDataSource: Get.find<TmdbRemoteDataSource>()),
    );

    // Register the use case. GetX injects the repository.
    Get.put(GetTrendingMoviesUseCase(repository: Get.find<MovieRepository>()));

    // Register the search use case. Same repository, different verb.
    Get.put(SearchMoviesUseCase(repository: Get.find<MovieRepository>()));

    // --- Presentation Layer ---
    // Register the HomeController. We use `lazyPut` so the controller
    // is only created when first accessed (saves startup time and
    // avoids triggering `onInit` if the user never visits the Home screen).
    Get.lazyPut(
      () => HomeController(useCase: Get.find<GetTrendingMoviesUseCase>()),
    );

    // The SearchController is also lazy for the same reason.
    Get.lazyPut(
      () => SearchController(useCase: Get.find<SearchMoviesUseCase>()),
    );

    // Watchlist: lives in memory for now. No use case yet — the controller
    // holds the state directly. In Section 6 we will add a use case that
    // syncs this list to Firestore.
    Get.lazyPut(() => WatchlistController());
  }
}
