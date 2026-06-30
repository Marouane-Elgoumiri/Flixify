import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/entities/progress_entity.dart';
import 'package:my_app/domain/entities/user_preferences.dart';

/// Abstract contract for storing per-user data in Firestore.
///
/// Today we use only the watchlist; tomorrow Section 6 (Vidking)
/// will hook into [saveProgress]/[getProgress].
abstract class UserDataRepository {
  // ──────────────── Watchlist ─────────────────────────

  /// Real-time stream of the user's watchlist.
  /// Emits an empty list on first read, then re-emits on every change.
  Stream<List<Movie>> watchWatchlist();

  /// One-shot read used for initial UI build.
  Future<List<Movie>> getWatchlist();

  Future<void> addToWatchlist(Movie movie);
  Future<void> removeFromWatchlist(int movieId);

  // ────────────── Continue Watching ───────────────────

  /// Read saved progress for a given mediaId. Null if not started.
  Future<ProgressEntity?> getProgress(int mediaId);

  /// Same as [getProgress] but returns the most-recently-updated row
  /// across ALL media. Used by the Home "Continue Watching" row.
  Future<ProgressEntity?> getLatestProgressFor(int mediaId);

  /// Read ALL progress rows for the user. Used for "Continue Watching" rows.
  Future<List<ProgressEntity>> getAllProgress();

  /// Upsert progress (Firestore merges if it exists).
  Future<void> saveProgress(ProgressEntity progress);

  // ──────────────── Preferences ───────────────────────

  Future<UserPreferences> getPreferences();
  Future<void> savePreferences(UserPreferences prefs);
}
