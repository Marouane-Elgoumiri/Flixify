/// Pure business entity representing a Movie.
///
/// This class is framework-independent. It has no dependencies on
/// Flutter, Dio, GetX, or any external package. It represents the
/// core business concept of a "Movie" in our domain.
///
/// WHY THIS MATTERS:
/// The Entity layer should NOT know about JSON, databases, or UI.
/// It only contains the data and business rules that are fundamental
/// to the domain. This is the "heart" of Clean Architecture.
class Movie {
  /// Creates a [Movie] with all fields required.
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
  });

  /// Unique identifier from TMDb.
  final int id;

  /// Movie title (may contain special characters, so not null).
  final String title;

  /// Plot summary / synopsis.
  final String overview;

  /// Path to the poster image (relative to TMDb image base URL).
  /// Can be null if the movie has no poster.
  final String? posterPath;

  /// Path to the backdrop image (relative to TMDb image base URL).
  /// Can be null if the movie has no backdrop.
  final String? backdropPath;

  /// ISO 8601 release date string, e.g. '2024-07-26'.
  final String? releaseDate;

  /// Average user rating (0- voteAverage
  /// Number of votes that contributed to the rating.
  final int voteCount;

  final dynamic voteAverage;

  /// Convenience getter for the full poster URL.
  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  /// Convenience getter for the full backdrop URL.
  String? get fullBackdropUrl =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/original$backdropPath'
          : null;

  /// Returns true if the movie was released recently (within 30 days).
  bool get isNewRelease {
    if (releaseDate == null) return false;
    try {
      final date = DateTime.parse(releaseDate!);
      final now = DateTime.now();
      return now.difference(date).inDays <= 30 && now.isAfter(date);
    } catch (_) {
      return false;
    }
  }

  /// Business rule: a movie is considered "highly rated" if its average
  /// is 8.0 or above and it has at least 1000 votes.
  bool get isHighlyRated =>
      voteAverage >= 8.0 && voteCount >= 1000;
}
