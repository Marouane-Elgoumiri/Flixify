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
