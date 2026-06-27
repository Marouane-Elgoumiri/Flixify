import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/usecases/get_trending_movies.dart';
import 'package:my_app/presentation/widgets/movie_card.dart';

/// The new Home Page that uses Clean Architecture.
///
/// This page demonstrates:
/// 1. How to get a Use Case from GetX DI
/// 2. How to call a use case with `NoParams`
/// 3. How to handle a [Result] (Success vs Error)
/// 4. Three-state UI: Loading, Error, Success
///
/// TEACHING FOCUS:
/// - The UI has NO direct knowledge of Dio, TMDb, or networking.
/// - It only depends on [GetTrendingMoviesUseCase] and [Movie] entities.
/// - This is a key principle of Clean Architecture.
class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  // GetX dependency injection: Get.find() looks up the registered use case.
  final GetTrendingMoviesUseCase _useCase =
      Get.find<GetTrendingMoviesUseCase>();

  // State for the UI
  late Future<Result<List<Movie>, Failure>> _fetchFuture;

  @override
  void initState() {
    super.initState();
    // Kick off the fetch when the widget is first built.
    _fetchFuture = _fetchMovies();
  }

  /// Calls the use case and returns a `Result`.
  /// We return a `Future<Result<...>>` rather than mutating state directly
  /// because the `FutureBuilder` pattern is cleaner for one-shot loads.
  Future<Result<List<Movie>, Failure>> _fetchMovies() {
    return _useCase.call(const NoParams());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flixify')),
      body: FutureBuilder<Result<List<Movie>, Failure>>(
        future: _fetchFuture,
        builder: (context, snapshot) {
          // State 1: Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // State 2: No data (impossible normally, but bug-tolerant)
          if (!snapshot.hasData) {
            return const Center(child: Text('Something went wrong.'));
          }

          // State 3: Use when() to handle both success and error cleanly.
          return snapshot.data!.when(
            success: (List<Movie> movies) => _MoviesGrid(movies: movies),
            error: (Failure failure) => Center(child: Text('Error: ${failure.message}')),
          );
        },
      ),
    );
  }
}

/// Extracted widget for the movie grid. Separates UI logic.
class _MoviesGrid extends StatelessWidget {
  const _MoviesGrid({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.md),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: AppDimensions.md,
        crossAxisSpacing: AppDimensions.md,
      ),
      itemBuilder: (context, index) => MovieCard(movie: movies[index]),
    );
  }
}
