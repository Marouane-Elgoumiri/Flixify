import 'package:flutter/material.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';

/// A reusable, declarative Movie Card widget that takes a [Movie] entity.
///
/// This widget receives its data through a typed [Movie] object — NOT a raw map.
/// This is a key principle of Clean Architecture: the UI works with entities,
/// not utility types like `Map<String, dynamic>`.
///
/// A truly declarative widget is a PURE FUNCTION of its inputs.
/// Given the same movie data, it always renders the same UI.
///
/// Benefits of typed entities:
/// 1. Compile-time error detection (typos, missing fields)
/// 2. IDE autocomplete support
/// 3. Refactor-safe (rename a field, the compiler guides you)
/// 4. Testable (mock the entity, no need to build fake maps)
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
  });

  /// The movie entity to display.
  final Movie movie;

  /// Optional callback when the watchlist button is tapped.
  /// When null, a snackbar feedback is shown.
  final VoidCallback? onWatchlistTap = null;

  @override
  Widget build(BuildContext context) {
    final title = movie.title;
    final rating = movie.voteAverage;
    final id = movie.id;
    final posterUrl = movie.fullPosterUrl;

    return Card(
      key: ValueKey(id),
      color: AppTheme.darkGrey,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Section - maintains the correct TMDb poster proportions (2:3)
          AspectRatio(
            aspectRatio: AppDimensions.movieCardAspectRatio,
            child: Container(
              color: AppTheme.secondaryBlack,
              alignment: Alignment.center,
              child: posterUrl != null
                  // We will show a real image in Section 4 with CachedNetworkImage.
                  // For now, an icon placeholder hints at the future implementation.
                  ? const Icon(Icons.image, color: AppTheme.lightGrey)
                  : const Icon(Icons.image_not_supported,
                      color: AppTheme.lightGrey),
            ),
          ),
          // Info Section
          Padding(
            padding: AppDimensions.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.movieCardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: AppDimensions.iconSm,
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTheme.bodyText.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                ElevatedButton.icon(
                  onPressed: () {
                    if (onWatchlistTap != null) {
                      onWatchlistTap!();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added "$title" to watchlist'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add, size: AppDimensions.iconSm),
                  label: const Text('Watchlist'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryText,
                    minimumSize: const Size(double.infinity, 36),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
