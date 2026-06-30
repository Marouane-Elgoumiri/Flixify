import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_route_names.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/presentation/controllers/home_controller.dart';
import 'package:my_app/presentation/widgets/category_row.dart';
import 'package:my_app/presentation/widgets/continue_watching_row.dart';
import 'package:my_app/presentation/widgets/hero_banner.dart';
import 'package:my_app/presentation/widgets/obx_demo.dart';

/// The Netflix-style Home Page — now powered by `GetBuilder`.
///
/// What this section teaches (Section 4):
///
/// 1. **`GetBuilder<T>`** — wraps the body of the page. Rebuilds ONLY when
///    we call `controller.update()` inside the controller.
/// 2. **No more `StatefulWidget`** — the page is now a `StatelessWidget`
///    because all state lives in [HomeController].
/// 3. **No more `FutureBuilder`** — the controller runs the fetch on `onInit()`
///    and exposes plain Dart fields (`trending`, `status`, `errorMessage`).
/// 4. **`Get.find<HomeController>()`** — used here WITHOUT a type cast.
///    Because we registered the controller globally in InitialBinding,
///    any widget can grab it.
///
/// (We deliberately do NOT use `Obx` or `.obs` here — those come in the bonus
/// step. Plain `GetBuilder` is the manual, explicit form.)
class NetflixHomePage extends StatelessWidget {
  const NetflixHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX dependency lookup: no constructor, no provider chain.
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Flixify',
          style: TextStyle(
            color: AppTheme.accentColor,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // Refresh icon lets the user re-fetch on demand.
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadTrending,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<HomeController>(
        builder: (controller) {
          // ── STATE 1: loading ──────────────────────────────────
          if (controller.status == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ── STATE 2: error ────────────────────────────────────
          if (controller.status == HomeStatus.error) {
            return _ErrorView(
              message: controller.errorMessage ?? 'Unknown error',
              onRetry: controller.loadTrending,
            );
          }

          // ── STATE 3: loaded (but possibly empty) ─────────────
          if (controller.trending.isEmpty) {
            return const Center(
              child: Text(
                'No trending movies right now.',
                style: TextStyle(color: AppTheme.lightGrey),
              ),
            );
          }

          // ── STATE 4: success ──────────────────────────────────
          final hero = controller.heroMovie!;
          final rest = controller.trending.skip(1).toList();
          return _NetflixBody(
            hero: hero,
            allMovies: rest,
            onNavTap: (i) {
              if (i == 1) Get.toNamed(AppRoutes.search);
            },
            onMovieTap: (m) => Get.toNamed('/details', arguments: m),
          );
        },
      ),
      bottomNavigationBar: _BottomNavBar(onTap: (index) {
        switch (index) {
          case 1:
            Get.toNamed(AppRoutes.search);
            break;
          case 2:
            Get.toNamed(AppRoutes.watchlist);
            break;
          case 3:
            Get.toNamed(AppRoutes.profile);
            break;
        }
      }),
    );
  }
}

/// The scrollable body — same as before, just stateless now.
class _NetflixBody extends StatelessWidget {
  const _NetflixBody({
    required this.hero,
    required this.allMovies,
    required this.onNavTap,
    required this.onMovieTap,
  });

  final Movie hero;
  final List<Movie> allMovies;
  final void Function(int index) onNavTap;
  final void Function(Movie movie) onMovieTap;

  @override
  Widget build(BuildContext context) {
    final trending = allMovies.take(8).toList();
    final topRated = allMovies.skip(2).take(8).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: HeroBanner(
            movie: hero,
            onPlayTap: () => onMovieTap(hero),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.md)),

        // Section 6 — Continue Watching (real Firestore data).
        // Reactive (Obx) — when the user saves progress from the
        // WebView, this row appears / moves automatically.
        SliverToBoxAdapter(
          child: Obx(() {
            final controller = Get.find<HomeController>();
            if (controller.isLoadingContinue.value &&
                controller.continueWatching.isEmpty) {
              return const SizedBox.shrink();
            }
            return ContinueWatchingRow(
              progressEntries: controller.continueWatching.toList(),
              moviesById: controller.moviesById,
              onTap: (m) => onMovieTap(m),
            );
          }),
        ),

        SliverToBoxAdapter(
          child: CategoryRow(
            title: 'Trending Now',
            movies: trending,
            onItemTap: onMovieTap,
          ),
        ),
        SliverToBoxAdapter(
          child: CategoryRow(
            title: 'Top Rated',
            movies: topRated,
            onItemTap: onMovieTap,
          ),
        ),
        const SliverToBoxAdapter(child: ObxDemo()),
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xl)),
      ],
    );
  }
}

/// Bottom nav — pure stateless now, no internal state.
/// State belongs to a controller when there's business logic,
/// but a UI-only tab indicator is fine to keep local.
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.onTap});
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: onTap,
      backgroundColor: AppTheme.secondaryBlack,
      selectedItemColor: AppTheme.accentColor,
      unselectedItemColor: AppTheme.lightGrey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_added_rounded),
          label: 'My List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// Friendly error view with a retry button.
/// This is what shows when the API call fails (no network, 401, 500...).
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 64, color: AppTheme.lightGrey),
            const SizedBox(height: AppDimensions.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.primaryText),
            ),
            const SizedBox(height: AppDimensions.lg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
