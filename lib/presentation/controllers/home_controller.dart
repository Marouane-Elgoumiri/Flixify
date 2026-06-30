import 'package:get/get.dart';

import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/entities/progress_entity.dart';
import 'package:my_app/domain/usecases/get_continue_watching.dart';
import 'package:my_app/domain/usecases/get_trending_movies.dart';

/// The states the Home screen can be in.
enum HomeStatus { initial, loading, loaded, error }

/// The controller for the Home screen.
///
/// Section 6 adds continue-watching integration:
/// `continueWatching` is a [RxList] driven by Firestore snapshots
/// via [GetContinueWatchingUseCase]'s repo (still GetX reactive).
/// `moviesById` lets the [ContinueWatchingRow] widget look up the
/// matching [Movie] entity for each [ProgressEntity].
class HomeController extends GetxController {
  HomeController({
    required GetTrendingMoviesUseCase useCase,
    required GetContinueWatchingUseCase continueWatchingUseCase,
  })  : _useCase = useCase,
        _continueUseCase = continueWatchingUseCase;

  final GetTrendingMoviesUseCase _useCase;
  final GetContinueWatchingUseCase _continueUseCase;

  // ─── Reactive state ─────────────────────────────────
  // Plain GetBuilder path (Section 4).
  List<Movie> trending = [];
  HomeStatus status = HomeStatus.initial;
  String? errorMessage;

  // Reactive path for the .obs / Obx Section 4 demo + Section 6.
  final RxList<Movie> reactiveTrending = <Movie>[].obs;
  final Rx<HomeStatus> reactiveStatus = HomeStatus.initial.obs;
  final RxString reactiveErrorMessage = ''.obs;

  // Section 6 — continue watching.
  final RxList<ProgressEntity> continueWatching = <ProgressEntity>[].obs;
  final RxBool isLoadingContinue = true.obs;

  RxInt counter = 0.obs;

  // ─── Derived ───────────────────────────────────────
  bool get isLoading => status == HomeStatus.loading;
  bool get hasError => status == HomeStatus.error;
  bool get hasData => trending.isNotEmpty;
  Movie? get heroMovie => trending.isNotEmpty ? trending.first : null;

  /// Map of `tmdbId -> Movie` of all loaded trending titles.
  /// Used by [ContinueWatchingRow] to join progress with movie details.
  Map<int, Movie> get moviesById => {
        for (final m in trending) m.id: m,
      };

  // ─────────────────── Methods ────────────────────────
  Future<void> loadTrending() async {
    try {
      status = HomeStatus.loading;
      errorMessage = null;
      reactiveStatus.value = HomeStatus.loading;
      reactiveErrorMessage.value = '';
      update();

      final result = await _useCase.call(const NoParams());
      result.when(
        success: (movies) {
          trending = movies;
          reactiveTrending.assignAll(movies);
          status = HomeStatus.loaded;
          reactiveStatus.value = HomeStatus.loaded;
        },
        error: (failure) {
          errorMessage = failure.message;
          reactiveErrorMessage.value = failure.message;
          status = HomeStatus.error;
          reactiveStatus.value = HomeStatus.error;
        },
      );
    } catch (e) {
      errorMessage = 'Unexpected error: $e';
      reactiveErrorMessage.value = 'Unexpected error: $e';
      status = HomeStatus.error;
      reactiveStatus.value = HomeStatus.error;
    } finally {
      update();
    }
  }

  /// Loads + subscribes to Continue Watching entries (Section 6).
  ///
  /// Right now we only do an initial `getAllProgress` read.
  /// Real Firestore live-snapshots will land when we wire `UserDataRepository`
  /// to its `users/{uid}/progress` collection snapshot method.
  Future<void> loadContinueWatching() async {
    isLoadingContinue.value = true;
    try {
      // Use the use case (result.when) to log failures consistently.
      await _continueUseCase(const NoParams()).then((result) => result.when(
            success: (rows) => continueWatching.assignAll(rows),
            error: (_) => continueWatching.assignAll(const <ProgressEntity>[]),
          ));
    } finally {
      isLoadingContinue.value = false;
    }
  }

  void bumpCounter() {
    counter.value++;
  }

  // ─── Lifecycle ───────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadTrending();
    loadContinueWatching();
  }
}

