import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized configuration for accessing TMDB API credentials.
///
/// Why a dedicated config class?
/// - Single source of truth for env variables
/// - Type-safe accessors (compile-time errors if you misspell)
/// - Default placeholders keep the app buildable even without a real .env
///
/// IMPORTANT:
/// Before the app can call TMDb, you must set valid values in `.env`:
/// - `TMDB_API_KEY=your_key`
/// - `TMDB_ACCESS_TOKEN=your_token`
class TmdbConfig {
  /// Private constructor — this is a static-only utility class.
  TmdbConfig._();

  /// Bearer token used in the `Authorization` header.
  /// TMDb requires `Authorization: Bearer <token>` for v3 endpoints.
  static String get accessToken =>
      dotenv.env['TMDB_ACCESS_TOKEN'] ?? 'PLACEHOLDER_REPLACE_ME';

  /// API key passed as the `api_key` query parameter.
  /// Used for endpoints that prefer the query-method over the header.
  static String get apiKey =>
      dotenv.env['TMDB_API_KEY'] ?? 'PLACEHOLDER_REPLACE_ME';
}
