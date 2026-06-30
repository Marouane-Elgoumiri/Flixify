import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/entities/progress_entity.dart';
import 'package:my_app/domain/entities/user_preferences.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';
import 'package:my_app/domain/repositories/user_data_repository.dart';

/// Firestore layout:
/// ```
/// users/{uid}
///   ├─ preferences   (document: darkMode, showAdultContent, defaultCategory)
///   ├─ watchlist/{movieId}
///   └─ progress/{mediaId}
/// ```
///
/// Resilience rules:
/// 1. If `_auth.currentUser == null` → return empty / no-op. No error.
/// 2. If Firebase returns `NOT_FOUND` (DB not yet provisioned) → return
///    empty + log once. Don't keep retrying on every call.
/// 3. Other errors: propagate.
class FirestoreUserDataRepository implements UserDataRepository {
  FirestoreUserDataRepository({
    required FirebaseFirestore firestore,
    required AuthRepository auth,
  })  : _fs = firestore,
        _auth = auth;

  final FirebaseFirestore _fs;
  final AuthRepository _auth;

  bool _warnedNotFound = false;

  /// True if [e] is a Firestore NOT_FOUND error meaning the DB doesn't
  /// exist (usually because the user just provisioned it but the SDK
  /// hasn't reconciled, or it's brand-new).
  static bool _isNotFound(Object e) {
    final str = e.toString();
    return str.contains('NOT_FOUND') ||
        str.contains('database (default) does not exist') ||
        str.contains('does not exist for project');
  }

  /// Common path for graceful NOT_FOUND handling.
  void _warnIfNotFound(Object e, String when) {
    if (_isNotFound(e)) {
      if (!_warnedNotFound) {
        developer.log(
          'Firestore NOT_FOUND while $when. '
          'Make sure the database is provisioned in Firebase Console.',
          name: 'FirestoreUserDataRepository',
        );
        _warnedNotFound = true;
      }
    }
  }

  /// Returns the users-doc for the current user, or null if not signed-in.
  DocumentReference<Map<String, dynamic>>? _userDoc() {
    final u = _auth.currentUser;
    if (u == null) return null;
    return _fs.collection('users').doc(u.uid);
  }

  // ─── Watchlist ─────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>>? _watchlist() =>
      _userDoc()?.collection('watchlist');

  @override
  Stream<List<Movie>> watchWatchlist() async* {
    final ref = _watchlist();
    if (ref == null) {
      yield const <Movie>[];
      return;
    }
    try {
      await for (final snap in ref
          .orderBy('addedAtMs', descending: true)
          .snapshots()) {
        yield snap.docs
            .map((d) => _movieFromDoc(d.id, d.data()))
            .toList();
      }
    } catch (e) {
      _warnIfNotFound(e, 'watching watchlist');
      yield const <Movie>[];
    }
  }

  @override
  Future<List<Movie>> getWatchlist() async {
    final ref = _watchlist();
    if (ref == null) return const <Movie>[];
    try {
      final snap = await ref.orderBy('addedAtMs', descending: true).get();
      return snap.docs
          .map((d) => _movieFromDoc(d.id, d.data()))
          .toList();
    } catch (e) {
      _warnIfNotFound(e, 'getting watchlist');
      return const <Movie>[];
    }
  }

  @override
  Future<void> addToWatchlist(Movie movie) async {
    final ref = _watchlist();
    if (ref == null) return;
    try {
      await ref.doc('${movie.id}').set({
        'id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'posterPath': movie.posterPath,
        'backdropPath': movie.backdropPath,
        'releaseDate': movie.releaseDate,
        'voteAverage': movie.voteAverage,
        'voteCount': movie.voteCount,
        'addedAtMs': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      _warnIfNotFound(e, 'adding to watchlist');
      rethrow;
    }
  }

  @override
  Future<void> removeFromWatchlist(int movieId) async {
    final ref = _watchlist();
    if (ref == null) return;
    try {
      await ref.doc('$movieId').delete();
    } catch (e) {
      _warnIfNotFound(e, 'removing from watchlist');
      rethrow;
    }
  }

  // ─── Progress ───────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>>? _progress() =>
      _userDoc()?.collection('progress');

  @override
  Future<ProgressEntity?> getProgress(int mediaId) async {
    final root = _userDoc();
    if (root == null) return null;
    try {
      final d = await root.collection('progress').doc('$mediaId').get();
      if (!d.exists) return null;
      return _progressFromDoc(mediaId, d.data()!);
    } catch (e) {
      _warnIfNotFound(e, 'getting progress $mediaId');
      return null;
    }
  }

  @override
  Future<ProgressEntity?> getLatestProgressFor(int mediaId) async {
    return getProgress(mediaId);
  }

  @override
  Future<List<ProgressEntity>> getAllProgress() async {
    final root = _userDoc();
    if (root == null) return const <ProgressEntity>[];
    try {
      final snap = await root
          .collection('progress')
          .orderBy('updatedAtMs', descending: true)
          .get();
      return snap.docs
          .map((d) => _progressFromDoc(int.parse(d.id), d.data()))
          .toList();
    } catch (e) {
      _warnIfNotFound(e, 'getting all progress');
      return const <ProgressEntity>[];
    }
  }

  @override
  Future<void> saveProgress(ProgressEntity progress) async {
    final ref = _progress();
    if (ref == null) return;
    try {
      await ref.doc('${progress.mediaId}').set({
        'mediaType': progress.mediaType,
        'currentSeconds': progress.currentSeconds,
        'durationSeconds': progress.durationSeconds,
        'season': progress.season,
        'episode': progress.episode,
        'updatedAtMs': progress.updatedAt.millisecondsSinceEpoch,
      });
    } catch (e) {
      _warnIfNotFound(e, 'saving progress');
      rethrow;
    }
  }

  // ─── Preferences ────────────────────────────────────────────────────────

  @override
  Future<UserPreferences> getPreferences() async {
    final root = _userDoc();
    if (root == null) return const UserPreferences();
    try {
      final d = await root.get();
      final data = d.data() ?? const <String, dynamic>{};
      return UserPreferences(
        darkMode: data['darkMode'] as bool? ?? true,
        showAdultContent: data['showAdultContent'] as bool? ?? false,
        defaultCategory: data['defaultCategory'] as String? ?? 'popular',
      );
    } catch (e) {
      _warnIfNotFound(e, 'getting preferences');
      return const UserPreferences();
    }
  }

  @override
  Future<void> savePreferences(UserPreferences prefs) async {
    final root = _userDoc();
    if (root == null) return;
    try {
      await root.set({
        'darkMode': prefs.darkMode,
        'showAdultContent': prefs.showAdultContent,
        'defaultCategory': prefs.defaultCategory,
      }, SetOptions(merge: true));
    } catch (e) {
      _warnIfNotFound(e, 'saving preferences');
      rethrow;
    }
  }

  // ─── helpers ────────────────────────────────────────────────────────────

  Movie _movieFromDoc(String id, Map<String, dynamic> data) {
    int parseInt(dynamic v) =>
        v is num ? v.toInt() : int.tryParse('$v') ?? 0;
    double parseDouble(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse('$v') ?? 0.0;

    return Movie(
      id: parseInt(data['id'] ?? id),
      title: data['title'] as String? ?? 'Unknown',
      overview: data['overview'] as String? ?? '',
      posterPath: data['posterPath'] as String?,
      backdropPath: data['backdropPath'] as String?,
      releaseDate: data['releaseDate'] as String?,
      voteAverage: parseDouble(data['voteAverage']),
      voteCount: parseInt(data['voteCount']),
    );
  }

  ProgressEntity _progressFromDoc(int id, Map<String, dynamic> data) {
    final updatedMs = (data['updatedAtMs'] as num?)?.toInt() ?? 0;
    return ProgressEntity(
      mediaId: id,
      mediaType: data['mediaType'] as String? ?? 'movie',
      currentSeconds: ((data['currentSeconds'] as num?) ?? 0).toDouble(),
      durationSeconds: ((data['durationSeconds'] as num?) ?? 0).toDouble(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedMs),
      season: (data['season'] as num?)?.toInt(),
      episode: (data['episode'] as num?)?.toInt(),
    );
  }
}
