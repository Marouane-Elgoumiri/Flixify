# 🧪 Flixify — Testing Plan

> Quality assurance and testing strategy for the Flixify app.

---

## 1. Testing Philosophy

 powders Testing is not an afterthought; it's a core part of the development process. We follow a **test-first** or **test-early** approach.

**Flutter Test Pyramid**:
```
     ^
     |  E2E Tests (Integration)
     |  (Very few, slow, cover full flows)
     |  
     |  Widget Tests
     |  (Many, medium speed, test UI & interaction)
     |  
     |  Unit Tests
     |  (Most, fast, test logic in isolation)
     +-------------------------->
```

---

## 2. Test Categories

### 2.1 Unit Tests
**Purpose**: Verify business logic, entity behaviors, and use cases in isolation.
**Target**: `lib/domain/`, `lib/data/`
**Framework**: `flutter_test` + `mockito` (for mocking dependencies)

**Coverage per Section**:

| Section | What to test |
|---------|-------------|
| Section 2 (Clean Arch) | Entity properties, Use Case logic, Repository behavior, Error mapping (`Either<Failure, T>`) |
| Section 4 (GetX) | Controller state logic, Rx variable updates, debounce logic |

**Example Tests**:
- `movie_test.dart` — Assert `Movie` entity handles null values correctly.
- `get_trending_movies_test.dart` — Mock the TMDB API and assert the Use Case returns a `List<Movie>`.
- `search_controller_test.dart` — Assert that typing "spider" triggers an API call after 500ms.

### 2.2 Widget Tests
**Purpose**: Verify that UI components render correctly and respond to user interaction.
**Target**: `lib/presentation/` (Widgets, Screens)
**Framework**: `flutter_test` + `WidgetTester`

**Coverage per Section**:

| Section | What to test |
|---------|-------------|
| Section 1 (Declarative) | Assert that updating state rebuilds the correct part of the widget tree. |
| Section 3 (UI) | Assert that `HomeScreen` has a `Hero Banner`, `ListView`s, and `BottomNavigationBar`. Test scroll behavior. |
| Section 4 (GetX) | Inject a `HomeController`, pump the `HomeScreen`, and verify `Obx` rebuilds when movies are loaded. |

**Example Tests**:
- `home_screen_test.dart` — Pump the screen, find a movie by title, tap it, and verify navigation to `DetailsScreen`.
- `custom_movie_card_test.dart` — Provide a `Movie` to the card, verify the poster network image is displayed, and the title text has the correct style.

### 2.3 Integration / E2E Tests
**Purpose**: Verify complete user flows across the entire app.
**Target**: Full application stack
**Framework**: `integration_test` (official package)

**Planned Flows**:
1. **Auth Flow**: Register -> Login -> See Home Screen -> Logout.
2. **Browse Flow**: Open app -> Scroll Trending -> Tap Movie -> See Details -> Tap "Watch Now" -> See WebView.
3. **Watchlist Flow**: Tap movie -> Add to Watchlist -> Navigate to My List -> Verify movie is there -> Remove it.
4. **Continue Watching**: Play a movie -> Seek to 50% -> Close player -> See "Continue Watching" card with 50% progress.

---

## 3. Testing Strategy by Section

### Section 1: Declarative vs Imperative
- [ ] **Widget Test**: Test that the `ValueNotifier` based counter correctly triggers UI updates.
- [ ] **Manual Test**: Verify that rapid clicks don't cause state desynchronization.

### Section 2: Clean Code Architecture
- [ ] **Unit Test**: Mock `TmdbRemoteDataSource` and verify `MovieRepositoryImpl` handles a 200 OK correctly.
- [ ] **Unit Test**: Verify `TmdbRemoteDataSource` throws a `ServerException` on 404 and the repository returns `Left(ServerFailure(...))`.

### Section 3: UI Principles
- [ ] **Widget Test**: Assert `HomeScreen` contains exactly 1 `HeroBanner` and 3 horizontal `ListView`s.
- [ ] **Widget Test**: Verify that `Flexible` and `Expanded` distribute space correctly in portrait and landscape mode.

### Section 4: GetX State Management
- [ ] **Widget Test**: Pump a screen with `GetX<HomeController>`, call `controller.fetchTrending()`, and verify the list updates.
- [ ] **Unit Test**: Test `debounce` on `SearchController` using `FakeAsync`.

### Section 5: Navigation
- [ ] **Widget Test**: Verify `BottomNavigationBar` changes the active tab and that each tab has separate navigation stacks.
- [ ] **Integration Test**: E2E flow from Home -> Tap Movie -> Back -> Tab "My List".

### Section 6: Firebase Auth & DB
- [ ] **Integration Test**: Register a user, perform actions, and verify data in Firestore.
- [ ] **Integration Test**: Test offline persistence — turn off Wi-Fi, add to watchlist, turn on Wi-Fi, verify data syncs.

---

## 4. Regression Test Checklist (Updated per Section)

Before moving to a new section, ensure the following still works:
- [ ] App compiles without errors or warnings.
- [ ] App launches successfully on Android.
- [ ] Previous sections' UI features are still functional.
- [ ] No analyzer (`flutter analyze`) warnings.
- [ ] All tests for completed sections pass (`flutter test`).

---

## 5. Tools & Commands

```bash
# Run all unit and widget tests
flutter test

# Run a specific test file
flutter test test/domain/entities/movie_test.dart

# Run integration tests
flutter test integration_test/app_test.dart

# Check code coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html # Requires lcov
```

---

*To be updated as we progress through sections.*
