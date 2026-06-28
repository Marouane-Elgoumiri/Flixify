import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';
// ignore: unused_import
import 'package:my_app/presentation/controllers/watchlist_controller.dart';
import 'package:my_app/presentation/widgets/poster_image.dart';

/// Compact horizontal carousel tile.
///
/// ROUND 2b — watchlist heart on every movie.
///
/// What this card teaches (Step A):
/// 1. Reactive heart overlay — a small icon overlaid with `Stack`.
/// 2. `Obx` + `RxList` targeting — wrapping the heart in `Obx(() => ...)`
///    means the heart is the ONLY widget that rebuilds when
///    WatchlistController.movies changes. The poster stays put.
/// 3. Co-existence of static + reactive — the poster image is
///    static (immutable widget), the heart is reactive (auto rebuilds).
/// 4. Self-contained widget — finds the controller itself via `Get.find()`,
///    no need to pass it down through the widget tree.
class MiniMovieCard extends StatelessWidget {
  const MiniMovieCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  final Movie movie;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // STEP A.1: Find the controller once. Hint:


    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: AppDimensions.movieCardAspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Layer A: the poster image (static).
              PosterImage(url: movie.fullPosterUrl),

              // Layer B: the subtle border (static).
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.darkGrey,
                    width: 1,
                  ),
                ),
              ),

              // +-----------------------------------------------+
              // | STEP A.2 : Add a Positioned heart here.       |
              // +-----------------------------------------------+
              //
              // Requirements:
              //   - Position it `top: 4, right: 4` (inside the tile).
              //   - Use IconButton with custom size constraints.
              //   - Wrap the WHOLE IconButton in an Obx(() => ...)
              //     so only the heart rebuilds.
              //
              // Inside the Obx you need to:
              //   1. Read state:
              //        final isInList = watchlist.containsId(movie.id);
              //   2. Pick icon:
              //        isInList ? Icons.favorite_rounded
              //                  : Icons.favorite_border_rounded
              //   3. Pick color:
              //        isInList ? AppTheme.accentColor
              //                  : AppTheme.primaryText
              //   4. onPressed -> watchlist.toggleWatchlist(movie)
              //
              // Tips:
              //   - IconButton.styleFrom(backgroundColor: Colors.black54)
              //     gives semi-transparent black behind the icon.
              //   - iconSize: 18, padding: EdgeInsets.zero,
              //     minimumSize: Size(28, 28) keeps it small.
              //
              // Reference: the heart in `hero_banner.dart` is
              // already implemented exactly like this.
              //
              Positioned(
                top: 4,
                right: 4,
                child: Obx(() {
                  // ↓ Replace these two lines with your STEP A.1 controller lookup
                  final watchlist = Get.find<WatchlistController>();
                  final isInList = watchlist.containsId(movie.id);

                  return IconButton(
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding: EdgeInsets.zero,
                      minimumSize: Size(28, 28),
                    ),
                    onPressed: () => watchlist.toggleWatchlist(movie),
                    icon: Icon(
                      isInList
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isInList
                          ? AppTheme.accentColor
                          : AppTheme.primaryText,
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
