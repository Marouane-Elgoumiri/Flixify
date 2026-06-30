/// Saved position for "Continue Watching".
///
/// Field name conventions are `camelCase` rather than `snake_case`
/// because this class is a domain object — the data layer maps
/// to Firestore-friendly snake_case keys when reading/writing.
class ProgressEntity {
  const ProgressEntity({
    required this.mediaId,
    required this.mediaType,   // 'movie' | 'tv'
    required this.currentSeconds,
    required this.durationSeconds,
    required this.updatedAt,
    this.season,
    this.episode,
  });

  final int mediaId;
  final String mediaType;
  final double currentSeconds;
  final double durationSeconds;
  final DateTime updatedAt;

  /// Set only when [mediaType] == 'tv'.
  final int? season;
  final int? episode;

  /// Fraction watched in [0.0, 1.0].
  double get percent {
    if (durationSeconds <= 0) return 0;
    final v = currentSeconds / durationSeconds;
    if (v.isNaN || v < 0) return 0;
    if (v > 1) return 1;
    return v;
  }
}
