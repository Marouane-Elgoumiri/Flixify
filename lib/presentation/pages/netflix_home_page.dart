import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/usecases/get_trending_movies.dart';
import 'package:my_app/presentation/widgets/category_row.dart';
import 'package:my_app/presentation/widgets/flexible_vs_expanded_demo.dart';
import 'package:my_app/presentation/widgets/hero_banner.dart';

/// The Netflix-style Home Page.
///
/// What this page teaches (Section 3):
///
/// 1. **Hero Banner at the top** — a `Stack` of three layers:
///    poster -> gradient overlay -> title + CTA buttons.
/// 2. **Horizontal category rows** — `ListView(scrollDirection: Axis.horizontal)`
///    renders 5-7 movies in a strip, just like Netflix.
/// 3. **The 7-number system** — every spacing/size value comes from
///    `AppDimensions.sm/md/lg/xl/...`. No magic numbers.
/// 4. **`Flexible` vs `Expanded`** — the body uses `Flexible` for the
///    scroller and `Expanded`-friendly patterns below.
/// 5. **Bottom Navigation Bar** — persistent navigation across the app.
///
/// All of this is built on the Clean Architecture layers from Section 2:
/// the UI only touches `UseCase` and `Movie` entity; no Dio, no JSON.
class NetflixHomePage extends StatefulWidget {
  const NetflixHomePage({super.key});

  @override
  State<NetflixHomePage> createState() => _NetflixHomePageState();
}

class _NetflixHomePageState extends State<NetflixHomePage> {
  final GetTrendingMoviesUseCase _useCase =
      Get.find<GetTrendingMoviesUseCase>();

  late Future<Result<List<Movie>, Failure>> _fetchFuture;

  @override
  void initState() {
    super.initState();
    _fetchFuture = _useCase.call(const NoParams());
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Result<List<Movie>, Failure>>(
        future: _fetchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Something went wrong.'));
          }

          return snapshot.data!.when(
            success: (List<Movie> movies) {
              if (movies.isEmpty) {
                return const Center(
                  child: Text('No trending movies right now.'),
                );
              }
              // First movie becomes the hero; rest become category rows.
              final hero = movies.first;
              final rest = movies.skip(1).toList();
              return _NetflixBody(hero: hero, allMovies: rest);
            },
            error: (Failure failure) =>
                Center(child: Text('Error: ${failure.message}')),
          );
        },
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

/// The scrollable body of the Netflix home screen.
///
/// Stack layout (top → bottom):
///   ▸ Hero Banner   ← top, fixed size via AspectRatio
///   ▸ Trending Row  ← horizontal scroller
///   ▸ Top Rated Row ← horizontal scroller
///   ▸ Continue Watching Row
///
/// We use [CustomScrollView] + [SliverList] so each row can occupy its
/// own sliver — the canonical pattern for staggered sections.
class _NetflixBody extends StatelessWidget {
  const _NetflixBody({required this.hero, required this.allMovies});

  final Movie hero;
  final List<Movie> allMovies;

  @override
  Widget build(BuildContext context) {
    // Slice the rest into 3 mock categories (since we only have one
    // trending list so far). In real life these would be 3 separate calls.
    final trending = allMovies.take(8).toList();
    final topRated = allMovies.skip(2).take(8).toList();
    final continueWatching = allMovies.skip(5).take(8).toList();

    return CustomScrollView(
      slivers: [
        // 1) Hero Banner as a sliver — fixed height via AspectRatio inside
        SliverToBoxAdapter(
          child: HeroBanner(
            movie: hero,
            onPlayTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Play: ${hero.title}')),
            ),
          ),
        ),
        // 2) Spacer between hero and rows
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.md)),
        // 3) Category rows
        SliverToBoxAdapter(
          child: CategoryRow(title: 'Trending Now', movies: trending),
        ),
        SliverToBoxAdapter(
          child: CategoryRow(title: 'Top Rated', movies: topRated),
        ),
        SliverToBoxAdapter(
          child: CategoryRow(
              title: 'Continue Watching', movies: continueWatching),
        ),
        // 4) Section 3 teaching demo: Flexible vs Expanded
        const SliverToBoxAdapter(child: FlexibleVsExpandedDemo()),
        // 5) Bottom padding so the last row isn't hugging the navbar
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xl)),
      ],
    );
  }
}

/// Persistent bottom navigation bar.
///
/// Wraps `BottomNavigationBar` to give it our dark theme + accent color.
/// The active tab is stored locally — no global state required yet
/// (Section 4 will promote this to a GetXController if needed).
class _BottomNavBar extends StatefulWidget {
  const _BottomNavBar();

  @override
  State<_BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (i) => setState(() => _index = i),
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
