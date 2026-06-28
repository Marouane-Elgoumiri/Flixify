import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';
// ignore: unused_import
import 'package:my_app/presentation/controllers/watchlist_controller.dart';
import 'package:my_app/presentation/widgets/poster_image.dart';

/// `MovieCard` — wide card with poster + title + rating + button.
///
/// ROUND 2b — watchlist heart on every movie.
///
/// What this card teaches (Step B):
/// 1. **Replacing an imperative snackbar button** with a reactive heart.
///    Same pattern as `HeroBanner` and `MiniMovieCard`, just in a Row.
/// 2. **Trade-offs**: We're dropping the wide "Watchlist" button
///    (text) to keep the card visually clean. The heart icon next to
///    the rating is the modern Netflix pattern.
/// 3. **Reusability**: Once you've implemented this, you can drop
///    `MovieCard` anywhere — the heart always works.
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
  });

  /// The movie entity to display.
  final Movie movie;

  // ignore: unused_field
  final VoidCallback? onWatchlistTap = null;

  @override
  Widget build(BuildContext context) {
    final title = movie.title;
    final rating = movie.voteAverage;
    final id = movie.id;

    // ──────────────────────────────────────────────────────────────
    // TODO ▢ STEP B.1  Grab the watchlist controller once here,
    //      same trick as in `MiniMovieCard`:
    //
    //        final watchlist = Get.find<WatchlistController>();
    //
    // ──────────────────────────────────────────────────────────────

    return Card(
      key: ValueKey(id),
      color: AppTheme.darkGrey,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Section — STATIC, no reactive behavior needed here.
          AspectRatio(
            aspectRatio: AppDimensions.movieCardAspectRatio,
            child: PosterImage(url: movie.fullPosterUrl),
          ),

          // ─── Info Section ──────────────────────────────────────
          Padding(
            padding: AppDimensions.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: AppTheme.movieCardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.sm),

                // ★ 8.5   ♥  ← the row we are going to modify
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.amber,
                        size: AppDimensions.iconSm),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      // ──────────────────────────────────────────────────
                      // TODO ▢ STEP B.2  Replace the existing `Text(rating...)`
                      //      with a Row that contains:
                      //         1. The rating text (existing logic).
                      //         2. A Spacer().
                      //         3. An `Obx(() => ...)` with a heart button.
                      //
                      //   The heart inside the Obx should:
                      //     • Watch watchlist.containsId(movie.id)
                      //     • Icons.favorite_rounded when in list,
                      //       Icons.favorite_border_rounded otherwise
                      //     • AppTheme.accentColor when in list,
                      //       AppTheme.primaryText otherwise
                      //     • Tap → watchlist.toggleWatchlist(movie)
                      //
                      //   You can use a plain `IconButton` (no background)
                      //   because the Card already has a dark background.
                      //
                      //   Tip: keep the IconButton tight — no padding,
                      //   minimumSize: Size(28, 28), iconSize: 18.
                      //
                      //   ──────────────────────────────────────────────────
                      child: Text(
                        rating.toStringAsFixed(1),
                        style: AppTheme.bodyText.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),

                // ──────────────────────────────────────────────────────
                // TODO ▢ STEP B.3  ⚠️  DELETE the entire `ElevatedButton.icon`
                //      block below. We're replacing it with a heart on the
                //      rating row above. Once you implement STEP B.2, the
                //      button below becomes redundant.
                //
                //   Delete this entire `ElevatedButton.icon(` ... `)` —
                //   including the comment header above the button.
                // ──────────────────────────────────────────────────────
                const SizedBox(height: AppDimensions.sm),
                ElevatedButton.icon(
                  onPressed: () {
                    // Leave this no-op for now — it's about to be removed.
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
