import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/presentation/widgets/poster_image.dart';

/// "More info" page — opens when the user taps a movie card or the hero.
///
/// Three sections (top → bottom):
///   ▸ Backdrop image (full URL)
///   ▸ Title, tagline, rating, runtime placeholder
///   ▸ Overview text + primary "Watch Now" CTA
class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final backdropUrl = movie.fullBackdropUrl ?? movie.fullPosterUrl;

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: CustomScrollView(
        slivers: [
          // ── Backdrop header ─────────────────────────────────────
          SliverAppBar(
            backgroundColor: AppTheme.primaryBlack,
            pinned: true,
            expandedHeight: 280,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PosterImage(url: backdropUrl),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00000000),
                          Color(0xFF000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Title + meta row ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
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
                        style: const TextStyle(color: AppTheme.primaryText),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      if (movie.releaseDate != null)
                        Text(
                          movie.releaseDate!.split('-').first,
                          style: const TextStyle(color: AppTheme.lightGrey),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Watch Now ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/player', arguments: movie);
                  },
                  icon: const Icon(Icons.play_arrow_rounded,
                      size: AppDimensions.iconMd),
                  label: const Text('Watch Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryText,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ),
          ),

          // ── Overview ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    movie.overview.isEmpty
                        ? 'No description available for this title.'
                        : movie.overview,
                    style: const TextStyle(
                      color: AppTheme.lightGrey,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
