import 'package:flutter/material.dart';

import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/entities/progress_entity.dart';
import 'package:my_app/presentation/widgets/mini_movie_card.dart';

/// The "Continue Watching" row on the Home screen.
///
/// Inputs are deliberately pre-joined outside this widget:
/// - `progressEntries`: ordered list from Firestore snapshot
/// - `moviesById`: map of TMDB id → Movie (could be null if VM scrub the
///   cached trending list, but in practice they're populated together)
///
/// Each progress entry produces a tile like:
///   ┌─────────────────┐
///   │   POSTER         │
///   │  ▌▌▌▌ (progress) │ ← rounded overlay showing %
///   │  ┌─┬─┬─┬─┬──┐    │
///   └─────────────────┘
class ContinueWatchingRow extends StatelessWidget {
  const ContinueWatchingRow({
    super.key,
    required this.progressEntries,
    required this.moviesById,
    this.onTap,
  });

  final List<ProgressEntity> progressEntries;
  final Map<int, Movie> moviesById;
  final ValueChanged<Movie>? onTap;

  @override
  Widget build(BuildContext context) {
    if (progressEntries.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          child: Text(
            'Continue Watching',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.xs,
            ),
            itemCount: progressEntries.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppDimensions.sm),
            itemBuilder: (context, index) {
              final entry = progressEntries[index];
              final movie = moviesById[entry.mediaId];
              if (movie == null) {
                return _MissingMovieTile(mediaId: entry.mediaId);
              }
              return _ContinueWatchingTile(
                movie: movie,
                progress: entry,
                onTap: () => onTap?.call(movie),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ContinueWatchingTile extends StatelessWidget {
  const _ContinueWatchingTile({
    required this.movie,
    required this.progress,
    this.onTap,
  });

  final Movie movie;
  final ProgressEntity progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MiniMovieCard(movie: movie, onTap: onTap),
          Positioned(
            left: 4,
            right: 4,
            bottom: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_circle_fill,
                    color: Colors.white, size: 28),
                const SizedBox(height: 2),
                LinearProgressIndicator(
                  value: progress.percent,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingMovieTile extends StatelessWidget {
  const _MissingMovieTile({required this.mediaId});
  final int mediaId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(
        'Coming soon\n(id: $mediaId)',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white54, fontSize: 11),
      ),
    );
  }
}
