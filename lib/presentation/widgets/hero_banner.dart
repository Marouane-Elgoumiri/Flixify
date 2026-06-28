import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/presentation/controllers/watchlist_controller.dart';
import 'package:my_app/presentation/widgets/poster_image.dart';

/// The Netflix-style "featured" Hero Banner.
///
/// What it teaches:
/// 1. `Stack` composes layers (poster → gradient overlay → title + buttons).
/// 2. The **7-number system** in action: every Padding, Icon size, and
///    BorderRadius comes from `AppDimensions` — no magic numbers.
/// 3. `LinearGradient` (top-to-bottom transparent -> black) makes any
///    image readable with a white title on top.
///
/// Layout (top-to-bottom):
/// ```
/// ┌──────────────────────────┐
/// │   POSter (full-bleed)    │   ← Stack layer 0
/// │  ┌────────────────────┐  │
/// │  │  Gradient overlay  │  │   ← Stack layer 1 (Container + BoxDecoration)
/// │  │  ┌──────────────┐  │  │
/// │  │  │  Title       │  │  │   ← Positioned layer 2
/// │  │  │  Play btn    │  │  │
/// │  │  └──────────────┘  │  │
/// │  └────────────────────┘  │
/// └──────────────────────────┘
/// ```
class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key, required this.movie, this.onPlayTap});

  final Movie movie;
  final VoidCallback? onPlayTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // 16:9 cinema ratio for the hero block — classic Netflix feel.
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 0: Real TMDB backdrop (or poster as fallback).
          // PosterImage handles loading/error states internally.
          PosterImage(url: movie.fullBackdropUrl ?? movie.fullPosterUrl),
          // Layer 1: Gradient overlay for text readability
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000), // Transparent at top
                  Color(0xCC000000), // ~80% black at bottom
                ],
              ),
            ),
          ),
          // Layer 2: Title + CTA buttons, anchored at bottom-left.
          // The WATCHLIST HEART lives on the top-right of this layer.
          Positioned.fill(
            child: Stack(
              children: [
                // Bottom-left text block (existing)
                Positioned(
                  left: AppDimensions.md,
                  right: AppDimensions.md,
                  bottom: AppDimensions.lg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: AppTheme.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber,
                              size: AppDimensions.iconSm),
                          const SizedBox(width: AppDimensions.xs),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                                color: AppTheme.lightGrey, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: onPlayTap,
                            icon: const Icon(Icons.play_arrow,
                                size: AppDimensions.iconMd),
                            label: const Text('Play'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentColor,
                              foregroundColor: AppTheme.primaryText,
                              minimumSize: const Size(120, 40),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.md),
                          OutlinedButton.icon(
                            onPressed: onPlayTap,
                            icon: const Icon(Icons.info_outline,
                                size: AppDimensions.iconMd,
                                color: AppTheme.primaryText),
                            label: const Text(
                              'Info',
                              style: TextStyle(color: AppTheme.primaryText),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppTheme.primaryText),
                              minimumSize: const Size(120, 40),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Top-right heart — Obx drives the icon + color.
                Positioned(
                  top: AppDimensions.md,
                  right: AppDimensions.md,
                  child: Obx(() {
                    final ctrl = Get.find<WatchlistController>();
                    final isInList = ctrl.containsId(movie.id);
                    return IconButton(
                      tooltip:
                          isInList ? 'Remove from My List' : 'Add to My List',
                      onPressed: () => ctrl.toggleWatchlist(movie),
                      icon: Icon(
                        isInList
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isInList
                            ? AppTheme.accentColor
                            : AppTheme.primaryText,
                        size: AppDimensions.iconMd + 8,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
