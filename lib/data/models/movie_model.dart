import 'package:json_annotation/json_annotation.dart';

import 'package:my_app/domain/entities/movie.dart';

part 'movie_model.g.dart';

/// Data Transfer Object (DTO) that maps TMDb API responses to Dart objects.
///
/// This class lives in the Data layer and is tightly coupled with JSON.
/// It knows about `json_annotation` and serialization details that the
/// Domain layer should never see.
///
/// SEPARATION OF CONCERNS:
/// - [MovieModel] handles API format (snake_case, nullable fields)
/// - [Movie] entity enforces business rules (non-null, typed)
/// - The mapping between them (toEntity/fromEntity) lives in the Data layer
///
/// The `@JsonSerializable` annotation tells `build_runner` to generate
/// `_$MovieModelFromJson` and `_$MovieModelToJson`, which we expose through
/// the public [fromJson]/[toJson] factories below.
@JsonSerializable()
class MovieModel {
  MovieModel({
    this.id,
    this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
  });

  /// TMDb movie ID.
  int? id;

  /// Movie title.
  String? title;

  /// Plot synopsis.
  String? overview;

  /// Path to poster image (e.g. '/yF2Jt0y5yT1V202rrXxzzQ96QVw.jpg').
  /// Maps from the JSON key 'poster_path' to the Dart field 'posterPath'.
  @JsonKey(name: 'poster_path')
  String? posterPath;

  /// Path to backdrop image.
  @JsonKey(name: 'backdrop_path')
  String? backdropPath;

  /// ISO 8601 release date string.
  @JsonKey(name: 'release_date')
  String? releaseDate;

  /// Average user rating (0-10).
  @JsonKey(name: 'vote_average')
  double? voteAverage;

  /// Total number of votes.
  @JsonKey(name: 'vote_count')
  int? voteCount;

  /// Converts a JSON map into a [MovieModel] instance.
  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  /// Converts a [MovieModel] instance into a JSON map.
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  /// Converts this model to a pure [Movie] entity.
  ///
  /// This is where we apply business rules:
  /// - Enforce non-null title with a default
  /// - Ensure id is not null (or provide a fallback; in practice,
  ///   valid API responses always have an id).
  Movie toEntity() {
    return Movie(
      id: id ?? 0,
      title: title ?? 'Unknown Title',
      overview: overview ?? '',
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage ?? 0.0,
      voteCount: voteCount ?? 0,
    );
  }
}
