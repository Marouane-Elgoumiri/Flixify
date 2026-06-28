import 'package:get/get.dart';

import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/usecases/get_trending_movies.dart';

/// The states the Home screen can be in.
enum HomeStatus { initial, loading, loaded, error }

/// The controller for the Home screen (`/netflix` route).
///
/// What it teaches:
/// 1. State lives OUTSIDE widgets, in a dedicated [GetxController].
/// 2. Each rebuild cycle calls back into our [loadTrending], which
///    re-fetches the trending list from TMDB.
/// 3. After mutating state, we call [update] which tells GetBuilder
///    to rebuild. That's the manual, explicit flow of `GetBuilder`.
///    (Step 6 shows the reactive `Obx` shortcut.)
///
/// Lifecycle hooks (`onInit`, `onReady`, `onClose`) give us textbook
/// creation / mount / disposal semantics — just like a ViewModel.
class HomeController extends GetxController {
  HomeController({required GetTrendingMoviesUseCase useCase})
      : _useCase = useCase;

  final GetTrendingMoviesUseCase _useCase;

  // ───────────────── State ─────────────────
  /// Reactive (`.obs`) variants of the same data. These are the
  /// "automatic rebuild" counterparts of the plain fields below.
  ///
  /// Why both? Because GetBuilder + plain fields is great for "manual
  /// control" demos, but reactive `.obs` is the production-grade form.
  /// Both live here so the home page can show *both* off side-by-side.
  final RxList<Movie> reactiveTrending = <Movie>[].obs;
  final Rx<HomeStatus> reactiveStatus = HomeStatus.initial.obs;
  final RxString reactiveErrorMessage = ''.obs;

  // Plain counterparts: what `GetBuilder` already reads today.
  List<Movie> trending = [];
  HomeStatus status = HomeStatus.initial;
  String? errorMessage;

  /// Reactive counter tied to [bumpCounter]. Use anywhere with `Obx`.
  RxInt counter = 0.obs;

  // ─────────── Computed helpers ───────────
  bool get isLoading => status == HomeStatus.loading;
  bool get hasError => status == HomeStatus.error;
  bool get hasData => trending.isNotEmpty;

  /// The first trending movie becomes the hero banner.
  /// If the list is empty, returns null.
  Movie? get heroMovie => trending.isNotEmpty ? trending.first : null;

  // ─────────────── Methods ─────────────────
  /// Fetches trending movies and updates [status] accordingly.
  /// Call this from `onInit()` for initial load, or from a
  /// "Refresh" button so the user can retry.
  ///
  /// Notice we now update BOTH plain and reactive fields in one pass —
  /// that's the bridge between Step 4's `GetBuilder` and Step 6's `Obx`.
  Future<void> loadTrending() async {
    try {
      // ── START: plain fields (GetBuilder path) ──
      status = HomeStatus.loading;
      errorMessage = null;
      // ── START: reactive fields (Obx path) ──
      reactiveStatus.value = HomeStatus.loading;
      reactiveErrorMessage.value = '';
      update();                       //  ← tell GetBuilder: please rebuild

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
      update();                       //  ← ALWAYS update at the end
    }
  }

  /// Increments [counter] (the reactive demo). Wire to a UI button.
  ///
  /// Note: NO `update()` is needed — `Obx(() => Text(counter.value))`
  /// already rebuilds automatically because it READ [counter.value].
  void bumpCounter() {
    counter.value++;
  }

  // ─────────── Lifecycle hooks ─────────────
  @override
  void onInit() {
    super.onInit();
    loadTrending();                   // kick off on creation
  }

  @override
  void onClose() {
    // If we had timers / streams / subscriptions, we'd dispose them here.
    // For now, nothing to clean up.
  }
}
