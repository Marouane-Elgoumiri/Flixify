import 'package:get/get.dart';

import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/usecases/search_movies.dart';

/// ⚠️  STEP 5: YOUR CHALLENGE
///
/// The state of the Search screen.
///
/// Your job is to implement [runSearch] below so that:
///   1. The status updates as the search flows through.
///   2. `update()` is called after each state change so the
///      `GetBuilder<SearchController>` in `SearchPage` rebuilds.
///   3. The success/error handling matches the user-facing flow.
///
/// Tests/Recipe:
///   • Tap the search button in the UI
///   • Type a query (e.g. "Spider")
///   • The page should show a spinner, then results
enum SearchStatus { idle, searching, found, empty, error }

class SearchController extends GetxController {
  SearchController({required SearchMoviesUseCase useCase}) : _useCase = useCase;

  // ignore: unused_field
  final SearchMoviesUseCase _useCase;

  // ─── State ───
  List<Movie> results = [];
  SearchStatus status = SearchStatus.idle;
  String? errorMessage;

  // ─── Derived ───
  bool get isSearching => status == SearchStatus.searching;

  /// Runs a free-text search and updates [status] accordingly.
  ///
  /// Steps inside this method:
  ///   1. If the query is empty, reset state (status=idle, results=[]) and `update()`.
  ///   2. Set status to [SearchStatus.searching], call `update()`.
  ///   3. Call `_useCase(SearchMoviesParams(query: query))` and `await`.
  ///   4. Use `result.when(success: ..., error: ...)`:
  ///         - success: status = SearchStatus.found OR SearchStatus.empty (if results.isEmpty)
  ///         - error:   status = SearchStatus.error, errorMessage = failure.message
  ///   5. Call `update()` again so the UI reflects the final state.
  ///
  /// Hints:
  ///   • `result` is a [Future<Result<List<Movie>, Failure>>]. The `when()` method
  ///     takes `success: (data) { ... }` and `error: (failure) { ... }`.
  ///   • Don't forget to handle the empty-string case at the top.
  Future<void> runSearch(String query) async {
    // TODO 1: if query is empty -> reset state and update, return.
    if(query.trim().isEmpty){
      status = SearchStatus.idle;
      results = [];
      errorMessage = null;
      update();
      return;
    }
    // TODO 2: set status = .searching, errorMessage = null, update().
    status = SearchStatus.searching;
    errorMessage = null;
    update();
    // TODO 3: call use case with SearchMoviesParams(query: query).
    final result = await _useCase(SearchMoviesParams(query: query));
    // TODO 4: on success: update results, status (.found or .empty).
    //          on error:   update errorMessage, status = .error.
    result.when(
      success: (movies){
        results = movies;
        status = movies.isEmpty ? SearchStatus.empty : SearchStatus.found;
      },
      error: (failure){
        errorMessage = failure.message;
        status = SearchStatus.error;
    }
    );
    // TODO 5: update() at the end.
    update();
  }

  @override
  void onClose() {
    // Nothing to clean up for now.
  }
}
