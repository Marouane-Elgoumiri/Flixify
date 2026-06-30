import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/domain/entities/movie.dart';
// Flutter's Material library ships its own `SearchController` (used by
// SearchAnchor/SearchBar). To avoid name collision, we import ours
// under the prefix `app`:
//   app.SearchController === our GetX controller
//   SearchController (no prefix) === Flutter's Material one
import 'package:my_app/presentation/controllers/search_controller.dart'
    as app;
import 'package:my_app/presentation/widgets/mini_movie_card.dart';

/// The Search screen. Hooks up the SearchController via `GetBuilder`.
///
/// This page is tied to the SearchController from Step 5 (your challenge).
/// It demonstrates the same `GetBuilder` pattern we used on the Home page,
/// but now driven by user typing in a TextField.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Local UI state — purely for the text field. NOT in the controller
  // because no other widget cares about it.
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app.SearchController controller = Get.find<app.SearchController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: AppTheme.primaryText),
              decoration: InputDecoration(
                hintText: 'Search movies...',
                filled: true,
                fillColor: AppTheme.darkGrey,
                prefixIcon: const Icon(Icons.search,
                    color: AppTheme.lightGrey),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: controller.runSearch,
            ),
          ),
          // The body rebuilds through GetBuilder when controller.update() fires.
          Expanded(
            child: GetBuilder<app.SearchController>(
              builder: (controller) {
                switch (controller.status) {
                  case app.SearchStatus.idle:
                    return const _Idle();
                  case app.SearchStatus.searching:
                    return const Center(child: CircularProgressIndicator());
                  case app.SearchStatus.empty:
                    return const Center(
                      child: Text('No movies matched.',
                          style: TextStyle(color: AppTheme.lightGrey)),
                    );
                  case app.SearchStatus.error:
                    return Center(
                      child: Text(
                        'Error: ${controller.errorMessage}',
                        style: const TextStyle(color: AppTheme.accentColor),
                      ),
                    );
                  case app.SearchStatus.found:
                    if (controller.results.isEmpty) {
                      return const Center(child: Text('No results.'));
                    }
                    return _Results(movies: controller.results);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search, size: 64, color: AppTheme.lightGrey),
          SizedBox(height: AppDimensions.md),
          Text(
            'Type a query above and hit enter.',
            style: TextStyle(color: AppTheme.lightGrey),
          ),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.movies});
  final List<Movie> movies;

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
      itemBuilder: (_, i) {
        final movie = movies[i];
        return MiniMovieCard(
          movie: movie,
          // Open the same details page as on Home so the user can
          // continue to play. Mirrors the Netflix-app behavior.
          onTap: () => Get.toNamed('/details', arguments: movie),
        );
      },
    );
  }
}
