import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/api_constants.dart';
import 'package:my_app/core/config/tmdb_config.dart';
import 'package:my_app/data/datasources/tmdb_remote_datasource.dart';
import 'package:my_app/data/repositories/firebase_auth_repository.dart';
import 'package:my_app/data/repositories/firestore_user_data_repository.dart';
import 'package:my_app/data/repositories/movie_repository_impl.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';
import 'package:my_app/domain/repositories/movie_repository.dart';
import 'package:my_app/domain/repositories/user_data_repository.dart';
import 'package:my_app/domain/usecases/get_continue_watching.dart';
import 'package:my_app/domain/usecases/get_trending_movies.dart';
import 'package:my_app/domain/usecases/reset_password.dart';
import 'package:my_app/domain/usecases/search_movies.dart';
import 'package:my_app/domain/usecases/sign_in.dart';
import 'package:my_app/domain/usecases/sign_out.dart';
import 'package:my_app/domain/usecases/sign_up.dart';
import 'package:my_app/presentation/controllers/auth_controller.dart';
import 'package:my_app/presentation/controllers/home_controller.dart';
import 'package:my_app/presentation/controllers/player_controller.dart';
import 'package:my_app/presentation/controllers/search_controller.dart';
import 'package:my_app/presentation/controllers/watchlist_controller.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Bootstraps the entire app:
/// TMDb (dio + repos + use cases) + Firebase (auth + firestore + repos) +
/// Section 6 controllers + use cases.
///
/// IMPORTANT: GetX resolves dependencies eagerly inside `Get.put`.
/// We MUST register every `Get.find(...)` target BEFORE any code that
/// tries to look it up. The order below is strict:
///
///   1. Dio + TMDb raw datasource
///   2. FirebaseAuth + FirebaseFirestore (raw SDK instances)
///   3. Repositories (Movie, Auth, UserData) — depend on (1) + (2)
///   4. Use Cases — depend on (3)
///   5. Controllers — depend on (3) + (4)
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final prettyLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    );

    // ── 1. TMDb low-level (Dio) ─────────────────────────────
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
    assert(() {
      dio.interceptors.add(prettyLogger);
      return true;
    }());
    Get.put(dio);

    // ── 2. Firebase raw SDK ──────────────────────────────────
    Get.put<FirebaseAuth>(FirebaseAuth.instance);
    Get.put<FirebaseFirestore>(FirebaseFirestore.instance);

    // ── 3a. TMDb data-source + repository ───────────────────
    Get.put<TmdbRemoteDataSource>(TmdbRemoteDataSource(dio: dio));
    Get.put<MovieRepository>(
      MovieRepositoryImpl(remoteDataSource: Get.find<TmdbRemoteDataSource>()),
    );

    // ── 3b. Firebase auth repository ─────────────────────────
    Get.put<AuthRepository>(
      FirebaseAuthRepository(firebaseAuth: Get.find<FirebaseAuth>()),
    );

    // ── 3c. Firestore user-data repository ───────────────────
    Get.put<UserDataRepository>(
      FirestoreUserDataRepository(
        firestore: Get.find<FirebaseFirestore>(),
        auth: Get.find<AuthRepository>(),
      ),
    );

    // ── 4. Use Cases ─────────────────────────────────────────
    // TMDb
    Get.put(
      GetTrendingMoviesUseCase(repository: Get.find<MovieRepository>()),
    );
    Get.put(
      SearchMoviesUseCase(repository: Get.find<MovieRepository>()),
    );
    // Firebase-backed
    Get.put(
      GetContinueWatchingUseCase(
        repository: Get.find<UserDataRepository>(),
      ),
    );
    final auth = Get.find<AuthRepository>();
    Get.put(SignInUseCase(auth));
    Get.put(SignUpUseCase(auth));
    Get.put(SignOutUseCase(auth));
    Get.put(ResetPasswordUseCase(auth));

    // ── 5. Controllers ───────────────────────────────────────
    Get.put(
      AuthController(
        authRepository: auth,
        signInUseCase: Get.find<SignInUseCase>(),
        signUpUseCase: Get.find<SignUpUseCase>(),
        signOutUseCase: Get.find<SignOutUseCase>(),
        resetPasswordUseCase: Get.find<ResetPasswordUseCase>(),
      ),
      permanent: true,
    );

    Get.lazyPut(
      () => HomeController(
        useCase: Get.find<GetTrendingMoviesUseCase>(),
        continueWatchingUseCase: Get.find<GetContinueWatchingUseCase>(),
      ),
    );
    Get.lazyPut(
      () => SearchController(useCase: Get.find<SearchMoviesUseCase>()),
    );
    Get.lazyPut(
      () => WatchlistController(userData: Get.find<UserDataRepository>()),
    );

    // PlayerController is PERMANENT — one instance shared across all
    // Player navigations. The page calls attachMovie()/detachMovie()
    // on entry/exit, but the instance itself stays alive so any
    // background bridge state (Firebase write buffers, etc.) survives
    // short-lived pages.
    Get.put(
      PlayerController(userDataRepo: Get.find<UserDataRepository>()),
      permanent: true,
    );
  }
}
