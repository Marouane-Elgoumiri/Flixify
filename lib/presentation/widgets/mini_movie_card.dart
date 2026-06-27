import 'package:flutter/material.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';

/// Compact, low-height horizontal list tile used inside
/// category carousels on the Netflix home screen.
///
/// Key difference from [MovieCard]:
/// - Wider (poster-mode) but MUCH shorter (no title block, no button).
/// - Designed to fit 6–8 items on screen at once.
/// - The category row provides the section title; this widget focuses
///   purely on the poster (icon for now, real image in Section 4).
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
    final posterUrl = movie.fullPosterUrl;
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: AppDimensions.movieCardAspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.secondaryBlack,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppTheme.darkGrey),
          ),
          alignment: Alignment.center,
          child: posterUrl != null
              ? const Icon(Icons.movie, color: AppTheme.lightGrey)
              : const Icon(Icons.movie_filter_outlined,
                  color: AppTheme.lightGrey),
        ),
      ),
    );
  }
}
