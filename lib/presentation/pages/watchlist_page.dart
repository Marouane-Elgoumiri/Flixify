import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/presentation/controllers/watchlist_controller.dart';
import 'package:my_app/presentation/widgets/mini_movie_card.dart';

/// The My List / Watchlist screen.
///
/// What this page demonstrates (Section 4 Challenge — Round 2):
///
/// 1. **`Obx(() => Text(...))`** — the count auto-updates the moment
///    `movies` changes. NO `update()` call from the controller.
/// 2. **`Obx(() => GridView)`** — the grid is built once; only the
///    `movies.length` and items list drive a rebuild when reactive.
/// 3. **`Obx` × 3 in one screen** — count, empty-state, and grid each
///    listening to the SAME RxList. Only the affected widget rebuilds.
/// 4. **`clearAll`** — the only place we explicitly use `update()`-free
///    reactive control flow.
class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // We pull the controller ONCE here. `Obx` doesn't require this;
    // it could lookup via Get.find() inside each builder, but holding
    // a local helps the analyzer.
    final WatchlistController controller = Get.find<WatchlistController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: secondaryBlackOrTransparent(context),
        elevation: 0,
        title: const Text(
          'My List',
          style: TextStyle(color: AppTheme.primaryText),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear all',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: controller.movies.isEmpty
                ? null
                : controller.clearAll,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            // ── Obx #1: live count ───────────────────────────────
            child: Obx(() {
              final n = controller.movies.length;
              return Text(
                '$n movie${n != 1 ? 's' : ''}',
                style: const TextStyle(
                  color: AppTheme.lightGrey,
                  fontSize: 13,
                  letterSpacing: 0.6,
                ),
              );
            }),
          ),
          Expanded(
            // ── Obx #2: list / empty state ─────────────────────────
            child: Obx(() {
              if (controller.movies.isEmpty) {
                return const _EmptyState();
              }
              return _WatchlistGrid(
                movies: controller.movies.toList(),
                onRemove: (m) => controller.toggleWatchlist(m),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Helper to keep the AppBar consistent with the surrounding dark theme.
  Color secondaryBlackOrTransparent(BuildContext context) =>
      AppTheme.secondaryBlack;
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.xl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border_rounded,
                size: 96, color: AppTheme.lightGrey),
            const SizedBox(height: AppDimensions.lg),
            const Text(
              'Your list is empty.',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            const Text(
              'Tap the heart on any movie to add it here.\n'
              'Then come back to this tab — it updates automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.lightGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchlistGrid extends StatelessWidget {
  const _WatchlistGrid({required this.movies, required this.onRemove});

  final List movies;
  final void Function(dynamic movie) onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.md),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: AppDimensions.sm,
        crossAxisSpacing: AppDimensions.sm,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        // Each tile shows the poster + a remove-overlay button.
        return Stack(
          fit: StackFit.passthrough,
          children: [
            MiniMovieCard(movie: movie),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                tooltip: 'Remove',
                iconSize: 22,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding: const EdgeInsets.all(4),
                  minimumSize: const Size(32, 32),
                ),
                onPressed: () => onRemove(movie),
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppTheme.primaryText,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
