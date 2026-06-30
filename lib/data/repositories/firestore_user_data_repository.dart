import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/entities/progress_entity.dart';
import 'package:my_app/domain/entities/user_preferences.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';
import 'package:my_app/domain/repositories/user_data_repository.dart';

/// Firestore layout used:
/// ```
/// users/{uid}
///   ├─ preferences   (document, fields: darkMode, showAdultContent, defaultCategory)
///   ├─ watchlist/{movieId}
///   │    fields: id, title, overview, posterPath, backdropPath,
///   │            releaseDate, voteAverage, voteCount, addedAtMs
///   └─ progress/{mediaId}
///        fields: mediaType, currentSeconds, durationSeconds,
///                updatedAtMs, season?, episode?
/// ```
class FirestoreUserDataRepository implements UserDataRepository {
  FirestoreUserDataRepository({
    required FirebaseFirestore firestore,
    required AuthRepository auth, // for currentUser
  })  : _fs = firestore,
        _auth = auth;

  final FirebaseFirestore _fs;
  final AuthRepository _auth;

  /// Returns the users-doc for the current user, or throws if not signed-in.
  DocumentReference<Map<String, dynamic>> _userDoc() {
    final u = _auth.currentUser;
    if (u == null) {
      throw StateError('No user is signed in');
    }
    return _fs.collection('users').doc(u.uid);
  }

  // ─── Watchlist ─────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _watchlist() =>
      _userDoc().collection('watchlist');

  @override
  Stream<List<Movie>> watchWatchlist() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(const <Movie>[]);

    return _fs
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .orderBy('addedAtMs', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => _movieFromDoc(d.id, d.data())).toList());
  }

  @override
  Future<List<Movie>> getWatchlist() async {
    final user = _auth.currentUser;
    if (user == null) return const <Movie>[];

    final snap = await _fs
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .orderBy('addedAtMs', descending: true)
        .get();
    return snap.docs
        .map((d) => _movieFromDoc(d.id, d.data()))
        .toList();
  }

  @override
  Future<void> addToWatchlist(Movie movie) async {
    await _watchlist().doc('${movie.id}').set({
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
  }

  @override
  Future<void> removeFromWatchlist(int movieId) async {
    await _watchlist().doc('$movieId').delete();
  }

  // ─── Progress ───────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _progress() =>
      _userDoc().collection('progress');

  @override
  Future<ProgressEntity?> getProgress(int mediaId) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final d = await _fs
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc('$mediaId')
        .get();
    if (!d.exists) return null;
    return _progressFromDoc(mediaId, d.data()!);
  }

  @override
  Future<List<ProgressEntity>> getAllProgress() async {
    final user = _auth.currentUser;
    if (user == null) return const <ProgressEntity>[];

    final snap = await _fs
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .orderBy('updatedAtMs', descending: true)
        .get();
    return snap.docs
        .map((d) => _progressFromDoc(int.parse(d.id), d.data()))
        .toList();
  }

  @override
  Future<void> saveProgress(ProgressEntity progress) async {
    await _progress().doc('${progress.mediaId}').set({
      'mediaType': progress.mediaType,
      'currentSeconds': progress.currentSeconds,
      'durationSeconds': progress.durationSeconds,
      'season': progress.season,
      'episode': progress.episode,
      'updatedAtMs': progress.updatedAt.millisecondsSinceEpoch,
    });
  }

  // ─── Preferences ────────────────────────────────────────────────────────

  @override
  Future<UserPreferences> getPreferences() async {
    final user = _auth.currentUser;
    if (user == null) return const UserPreferences();

    final d = await _fs.collection('users').doc(user.uid).get();
    final data = d.data() ?? const <String, dynamic>{};
    return UserPreferences(
      darkMode: data['darkMode'] as bool? ?? true,
      showAdultContent: data['showAdultContent'] as bool? ?? false,
      defaultCategory: data['defaultCategory'] as String? ?? 'popular',
    );
  }

  @override
  Future<void> savePreferences(UserPreferences prefs) async {
    await _userDoc().set({
      'darkMode': prefs.darkMode,
      'showAdultContent': prefs.showAdultContent,
      'defaultCategory': prefs.defaultCategory,
    }, SetOptions(merge: true));
  }

  // ─── helpers ────────────────────────────────────────────────────────────

  Movie _movieFromDoc(String id, Map<String, dynamic> data) {
    int parseInt(dynamic v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;
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
      currentSeconds:
          ((data['currentSeconds'] as num?) ?? 0).toDouble(),
      durationSeconds:
          ((data['durationSeconds'] as num?) ?? 0).toDouble(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedMs),
      season: (data['season'] as num?)?.toInt(),
      episode: (data['episode'] as num?)?.toInt(),
    );
  }
}
