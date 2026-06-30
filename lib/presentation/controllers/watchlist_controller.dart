import 'dart:async';

import 'package:get/get.dart';

import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/repositories/user_data_repository.dart';

/// Persists the user's watchlist in **Firestore** (per-user collection).
///
/// This controller is now backed by [UserDataRepository]. The
/// `RxList<Movie>` is initialised from a one-shot read in `onInit`,
/// then kept in sync with Firestore's real-time stream.
///
/// Migration note (Section 4 R2 -> Section 5):
///   - Before: held everything in memory (cleared on app restart).
///   - Now:    syncs to Firestore, so the watchlist survives restarts.
///
/// The UI (WatchlistPage, hearts on cards, etc.) is identical because
/// it only ever reads from the `RxList`.
class WatchlistController extends GetxController {
  WatchlistController({required UserDataRepository userData})
      : _repo = userData;

  final UserDataRepository _repo;

  // ─── Reactive state ─────────────────────────────────
  final RxList<Movie> movies = <Movie>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<List<Movie>>? _sub;

  int get count => movies.length;

  bool contains(Movie m) => movies.any((x) => x.id == m.id);
  bool containsId(int id) => movies.any((x) => x.id == id);

  // ─── Lifecycle ───────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    try {
      final initial = await _repo.getWatchlist();
      movies.assignAll(initial);
    } finally {
      isLoading.value = false;
    }
    // Then subscribe to live changes from Firestore.
    _sub = _repo.watchWatchlist().listen((latest) {
      movies.assignAll(latest);
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  // ─── Commands ────────────────────────────────────────

  Future<void> toggleWatchlist(Movie movie) async {
    if (containsId(movie.id)) {
      await _repo.removeFromWatchlist(movie.id);
    } else {
      await _repo.addToWatchlist(movie);
    }
    // The Firestore stream listener will push the new list back to us.
  }

  Future<void> clearAll() async {
    // Delete from Firestore one-doc-at-a-time (free version is fine).
    final snapshot = List<Movie>.from(movies);
    for (final m in snapshot) {
      await _repo.removeFromWatchlist(m.id);
    }
  }
}
