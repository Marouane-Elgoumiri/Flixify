/// Centralized list of API endpoints and other app constants.
class ApiConstants {
  ApiConstants._(); // Private constructor

  // --- TMDb API Configuration ---
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // --- Vidking Provider ---
  static const String vidkingBaseUrl = 'https://www.vidking.net/embed';

  // --- API Endpoints ---
  static String getMovieDetails(int movieId) => '/movie/$movieId';
  static String getTvShowDetails(int tvId) => '/tv/$tvId';
  static String getTrendingMovies([String timeWindow = 'week']) => '/trending/movie/$timeWindow';
  static String getTopRatedMovies() => '/movie/top_rated';

  // --- User Account Endpoints ---
  static String getRatedMovies(int accountId) => '/account/$accountId/rated/movies';

  // Note: API Key and Access Token should be stored in the .env file.
  // Do not hardcode them here.
}

  /// Build Vidking embed URLs.
  ///
  /// Public so the controller can compose embed URLs the same way
  /// the PlayerPage expects.
  class VidkingUrls {
    VidkingUrls._();

    /// `https://www.vidking.net/embed/movie/{tmdbId}`
    static String movie(int tmdbId) =>
        '$vidkingBaseUrlOrigin/embed/movie/$tmdbId';

    /// `https://www.vidking.net/embed/tv/{tmdbId}/{season}/{episode}`
    static String tvShow(int tmdbId, {int season = 1, int episode = 1}) =>
        '$vidkingBaseUrlOrigin/embed/tv/$tmdbId/$season/$episode';

    static const String vidkingBaseUrlOrigin = 'https://www.vidking.net';
  }
