import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import 'package:my_app/core/constants/api_constants.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/entities/progress_entity.dart';
import 'package:my_app/domain/repositories/user_data_repository.dart';

/// Hybrid save strategy:
///   • `timeupdate` is debounced to once every 30 seconds.
///   • `pause` and `ended` always save immediately.
enum PlayerEventType { timeupdate, play, pause, ended, seeked, unknown }

/// Possible [PlayerEventType]s recognized by Vidking.
/// The iframe dispatches a string like:
///   `{"event":"pause","currentTime":120.5,"duration":7200,"id":"299534","mediaType":"movie"}`
class PlayerController extends GetxController {
  PlayerController({required this.userDataRepo});

  /// Held by reference — Firestore-backed in Section 5.
  final UserDataRepository userDataRepo;

  // ─── State ─────────────────────────────────────────
  /// What we're playing right now.
  /// Set by [attachMovie] when entering [PlayerPage].
  final Rxn<Movie> movie = Rxn<Movie>();

  /// Absolute URL used by WebView. Updates when movie changes.
  final RxString embedUrl = ''.obs;

  /// Once player fires its first event we hide the loader.
  final RxBool isReady = false.obs;

  /// Toggle the back arrow visibility on tap.
  final RxBool showBackButton = true.obs;

  // ─── Internal: hybrid save state ───────────────────
  DateTime _lastSavedAt = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _saveInterval = Duration(seconds: 30);

  /// Attaches a movie, computes embed URL.
  void attachMovie(Movie m) {
    movie.value = m;
    embedUrl.value = VidkingUrls.movie(m.id);
    isReady.value = false;
    _lastSavedAt = DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Called from `PlayerPage.dispose` to clean state.
  void detachMovie() {
    movie.value = null;
    embedUrl.value = '';
    isReady.value = false;
  }

  /// Toggle the back arrow on tap (Player gesture handler).
  void toggleBackButton() {
    showBackButton.value = !showBackButton.value;
  }

  /// Called from the WebView's JS message channel.
  void onPlayerMessage(String raw) {
    Map<String, dynamic>? data;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) data = decoded;
    } catch (_) {
      // Some Vidking messages might not be JSON; ignore them.
      return;
    }
    if (data == null) return;

    final event = _classify(data['event']);
    if (event == PlayerEventType.unknown) return;
    if (event != PlayerEventType.timeupdate) isReady.value = true;

    final persisted = _shouldSave(event);
    if (!persisted) return;

    final progress = _toEntity(data);
    if (progress == null) return;
    _persist(progress);
  }

  PlayerEventType _classify(dynamic eventName) {
    switch (eventName) {
      case 'timeupdate':
        return PlayerEventType.timeupdate;
      case 'play':
        return PlayerEventType.play;
      case 'pause':
        return PlayerEventType.pause;
      case 'ended':
        return PlayerEventType.ended;
      case 'seeked':
        return PlayerEventType.seeked;
      default:
        return PlayerEventType.unknown;
    }
  }

  /// Hybrid rule:
  ///   • Pause/Ended → save now.
  ///   • Timeupdate → save at most once every 30 seconds.
  bool _shouldSave(PlayerEventType event) {
    if (event == PlayerEventType.pause || event == PlayerEventType.ended) {
      return true;
    }
    if (event == PlayerEventType.timeupdate) {
      final now = DateTime.now();
      if (now.difference(_lastSavedAt) >= _saveInterval) {
        _lastSavedAt = now;
        return true;
      }
    }
    return false;
  }

  ProgressEntity? _toEntity(Map<String, dynamic> data) {
    final m = movie.value;
    if (m == null) return null;

    final id = _asInt(data['id']) ?? m.id;
    final type = _asString(data['mediaType']) ?? 'movie';
    final current = _asDouble(data['currentTime']) ?? 0;
    final duration = _asDouble(data['duration']) ?? 0;
    if (duration <= 0) return null;

    return ProgressEntity(
      mediaId: id,
      mediaType: type,
      currentSeconds: current,
      durationSeconds: duration,
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _persist(ProgressEntity progress) async {
    // Fire-and-forget — we don't block the UI on Firestore.
    unawaited(_saveProgress(progress));
  }

  Future<void> _saveProgress(ProgressEntity progress) async {
    try {
      await userDataRepo.saveProgress(progress);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to save progress: $e');
    }
  }

  // ─── Coercion helpers ──────────────────────────────────
  int? _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  double? _asDouble(dynamic v) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  String? _asString(dynamic v) {
    if (v is String) return v;
    if (v != null) return v.toString();
    return null;
  }
}
