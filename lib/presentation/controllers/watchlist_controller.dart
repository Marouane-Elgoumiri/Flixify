import 'package:get/get.dart';

import 'package:my_app/domain/entities/movie.dart';

/// Persists (in-memory for Section 4) the user's watchlist.
///
/// What this controller does:
/// 1. Holds a **reactive** list `RxList<Movie>` — any widget reading it
///    inside an `Obx` rebuilds automatically when it changes.
/// 2. Exposes [count] and [contains] as reactive derived values.
/// 3. Provides [toggleWatchlist] which adds/removes a movie.
///
/// In a real app this would ALSO sync with Firebase Firestore (Section 5).
/// For now, state lives only in memory. That keeps the focus on **how**
/// reactivity works, not on networking.
class WatchlistController extends GetxController {
  // ─── Reactive state ───
  /// The actual list. `RxList` is a special GetX wrapper around `List`
  /// that auto-notifies listeners when we call `.add()` / `.remove()` /
  /// `.assignAll()` / `.clear()`.
  final RxList<Movie> movies = <Movie>[].obs;

  /// Total number of items. Not reactive on its own — anyone reading
  /// `movies.length` inside an `Obx` already gets reactive behavior.
  int get count => movies.length;

  /// True if this movie is already in the list.
  /// Note: this is a regular getter (not reactive) — it just queries
  /// the underlying list. Same reactivity trick applies when read
  /// from inside an Obx.
  bool contains(Movie m) => movies.any((x) => x.id == m.id);

  /// True if this movie is already in the list — overload by id.
  bool containsId(int id) => movies.any((x) => x.id == id);

  /// ─────────── YOUR CHALLENGE ───────────
  /// ⚠️ Implement this method.
  ///
  /// Goal: if `movie` is already in the list, REMOVE it;
  ///       if it's NOT in the list, ADD it.
  ///
  /// IMPORTANT: because `movies` is an `RxList`, your final state must
  /// be visible to any `Obx(() => ... movies.length ...)` widget
  /// automatically — NO need to call `update()` for those readers.
  ///
  /// Steps:
  ///   1. Check if the list already contains a movie with the SAME id
  ///      (use `containsId` from above).
  ///   2. If yes: remove it. Hint — react to this with `movies.remove(...)`
  ///      or `movies.removeWhere(...)`.
  ///   3. If no:  add it. Hint — `movies.add(movie)`.
  ///
  /// The heart button in the HeroBanner taps into this; the WatchlistPage
  /// shows the live count via `Obx(() => Text('${ctrl.movies.length}'))`.
  void toggleWatchlist(Movie movie) {

    // TODO 1: use containsId() to decide add vs remove.
    if(containsId(movie.id)){
      movies.removeWhere((x) => x.id == movie.id);
    }else{
      movies.add(movie);
    }
    // TODO 2: react to RxList so listeners auto-rebuild.

  }
  /// Convenience used by the Watchlist page's "Clear" action.
  void clearAll() {
    movies.clear();                  // reactive: counts/list rebuild
  }
}
