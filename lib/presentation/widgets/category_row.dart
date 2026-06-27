import 'package:flutter/material.dart';

import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/presentation/widgets/mini_movie_card.dart';

/// A horizontally-scrollable category row, exactly like Netflix's
/// "Trending Now" or "Continue Watching for You" sections.
///
/// What it teaches:
/// 1. `scrollDirection: Axis.horizontal` flips the axis.
/// 2. `ListView.builder` is lazy — only the visible items are built.
/// 3. The 7-number system: every spacing value comes from
///    `AppDimensions.sm` / `md` / `lg`.
/// 4. `Padding(padding: EdgeInsets.symmetric(horizontal: ...))` ensures
///    the first/last card aren't flush against the screen edge.
class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.title,
    required this.movies,
    this.onItemTap,
  });

  final String title;
  final List<Movie> movies;
  final ValueChanged<Movie>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title — kept tight against the row with 0 vertical
        // padding; the gap is provided by `SizedBox(height: ...)` below.
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: 0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(
          // We use a fixed, sane height for the row. Each item is ~140
          // wide so 6 items show on most phones. The actual height is
          // computed from the card aspect ratio + padding.
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.xs,
            ),
            itemCount: movies.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppDimensions.sm),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return SizedBox(
                width: 140,
                child: MiniMovieCard(
                  movie: movie,
                  onTap: () => onItemTap?.call(movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
