/// Centralized list of API endpoints and other app constants.
class ApiConstants {
  ApiConstants._(); // Private constructor

  // --- TMDb API Configuration ---
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // --- Vidsync Provider Base URL ---
  static const String vidsyncBaseUrl = 'https://vidsync.live/embed';

  // --- TMDb API Endpoints ---
  static String getMovieDetails(int movieId) => '/movie/$movieId';
  static String getTvShowDetails(int tvId) => '/tv/$tvId';
  static String getTrendingMovies([String timeWindow = 'week']) =>
      '/trending/movie/$timeWindow';
  static String getTopRatedMovies() => '/movie/top_rated';

  // --- User Account Endpoints ---
  static String getRatedMovies(int accountId) =>
      '/account/$accountId/rated/movies';
}

/// Build Vidsync embed URLs.
///
/// Reference (from vidsync.live docs, 2026):
///   • Movie: `https://vidsync.live/embed/movie/{tmdbId}?autoPlay=true`
///   • TV:    `https://vidsync.live/embed/tv/{tmdbId}/{season}/{episode}?autoPlay=true`
///
/// Optional params:
///   • `autoPlay`  — boolean, starts playback automatically
///   • `startTime` — resume playback from N seconds (uses `?startTime=`)
///   • `theme`     — hex color, e.g. `16A0B5` (no `#` prefix)
class VidsyncUrls {
  VidsyncUrls._();

  /// Movie embed URL.
  ///
  /// Returns the standard movie embed URL with all configured query
  /// params (startTime, autoPlay, theme, etc.). Always `autoPlay=true`
  /// in our app — the user explicitly tapped "Watch Now".
  static String movie(
    int tmdbId, {
    int? startTime,
    String? theme,
  }) {
    final params = <String, String>{
      'autoPlay': 'true',
      if (startTime != null && startTime > 0) 'startTime': '$startTime',
      if (theme != null) 'theme': theme.replaceAll('#', ''),
    };
    return _buildUrl('movie/$tmdbId', params);
  }

  /// TV show embed URL.
  static String tvShow(
    int tmdbId, {
    int season = 1,
    int episode = 1,
    int? startTime,
    String? theme,
  }) {
    final params = <String, String>{
      'autoPlay': 'true',
      if (startTime != null && startTime > 0) 'startTime': '$startTime',
      if (theme != null) 'theme': theme.replaceAll('#', ''),
    };
    return _buildUrl('tv/$tmdbId/$season/$episode', params);
  }

  /// Build the URL with query params appended.
  static String _buildUrl(String path, Map<String, String> params) {
    final base = '${ApiConstants.vidsyncBaseUrl}/$path';
    if (params.isEmpty) return base;
    final qs = params.entries
        .map((e) =>
            '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return '$base?$qs';
  }
}
