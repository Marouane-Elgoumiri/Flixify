# 🎬 Flixify — Flutter Learning Sprint

> A Netflix-style streaming app built to master Flutter, GetX, Clean Architecture, and Firebase.

---

## 📋 Sprint Overview

| Item | Details |
|------|---------|
| **Project Name** | Flixify |
| **Purpose** | Learn Flutter by doing, building a Netflix-style streaming app |
| **Architecture** | Clean Architecture with GetX state management |
| **Target** | Android (primary) |
| **Current Section** | Section 3: UI Principles & Netflix-Style Layout |

---

## 🎯 Learning Objectives (MUST COVER)

1. ✅ **Descriptive vs Imperative Programming** — Understand Flutter's declarative paradigm
2. ✅ **Clean Code Architecture** — SOLID, Repository Pattern, Domain-Driven Design
3. ✅ **UI Principles**: Rows, Columns, 7-Number Dimensions, Flexible vs Expanded
4. ✅ **State Management**: GetX, GetBuilder, GetXController + Rx/Obs
5. ✅ **Firebase Integration**: Auth + Firestore Cloud Database

---

## 🛤️ Learning Sections

### Section 0: Project Bootstrapping & Environment Setup
**Status**: ✅ COMPLETED
**Goal**: Initialize the project with all dependencies, folder structure, and clean architecture foundation.
**Deliverables**:
- [x] pubspec.yaml with all dependencies
- [x] Clean folder structure (core, data, domain, presentation)
- [x] Android configuration (minSdk, permissions, manifest)
- [x] Base theme and constants
- [x] Analysis options configuration
- [x] Challenge completed: Added `getTopRatedMovies()` endpoint and `actionButton` TextStyle

---

### Section 1: Declarative vs Imperative Programming
**Status**: ⏳ NOT STARTED
**Goal**: Understand the core paradigm shift that makes Flutter unique.
**Deliverables**:
- [ ] Counter app rethought: First imperatively, then declaratively.
- [ ] `MovieCard` widget built both ways.
- [ ] Understanding `setState` and why it's a "bridge" to reactive patterns.

**Teaching Focus**:
- The mental shift from *"How do I change this widget?"* to *"What does the UI look like in this state?"*
- The Widget tree as a pure function of State.

---

### Section 2: Clean Code Architecture
**Status**: ✅ COMPLETED
**Goal**: Build a scalable foundation using SOLID principles.
**Deliverables**:
- [x] Domain layer (Entities, Abstract Repositories, Use Cases)
- [x] Data layer (Models, Data Sources, Repository Impl)
- [x] Presentation layer (Widgets, Controllers)
- [x] Dependency Injection with GetX
- [x] Error handling with `Result<Success, Failure>`

**Teaching Focus**:
- Why a clean architecture is necessary for a real production app.
- The flow of data: UI -> Controller -> Use Case -> Repository -> Data Source -> API.
- Dependency Inversion (Depend on abstractions, not concretions).

---

### Section 3: UI Principles & Netflix-Style Layout
**Status**: ✅ COMPLETED
**Goal**: Master Row/Column/Stack layouts and the 7-number dimension system.
**Deliverables**:
- [x] Netflix-style home screen (Hero Banner, Category Rows)
- [x] Horizontal scrolling carousels with `ListView`
- [x] Bottom navigation (Home, Search, My List, Profile)
- [x] Themes, custom widgets, and the 7-number system
- [x] Flexible vs Expanded comparison demo

**Teaching Focus**:
- The Flutter box model: constraints go DOWN, sizes go UP.
- `Row` & `Column` alignment and `MainAxis` / `CrossAxis`.
- `Flexible` vs `Expanded`: the difference that makes or breaks a layout.

---

### Section 4: GetX State Management (Rx + Obs + GetBuilder)
**Status**: ⏳ NOT STARTED
**Goal**: Replace manual state management with powerful reactive streams.
**Deliverables**:
- [ ] GetX setup with `GetMaterialApp`
- [ ] Controllers for Home, Search, Watchlist screens
- [ ] Reactive state with `RxList<T>`, `RxBool`, `RxString`
- [ ] `Obx`, `GetBuilder`, `GetX` in action

**Teaching Focus**:
- How reactive programming works (Observer pattern).
- When to use `GetBuilder` (explicit, one-time update) vs `Obx` (auto-listening to specific variables).
- Avoiding `setState` and building a production-quality app.

---

### Section 5: Firebase Auth & Firestore
**Status**: ⏳ NOT STARTED
**Goal**: Add authentication and persistent data storage.
**Deliverables**:
- [ ] Firebase project setup and Android configuration
- [ ] Auth flow: Register, Login, Logout, Password Reset
- [ ] Firestore collections for user watchlist and playback progress
- [ ] Continue Watching feature

**Teaching Focus**:
- Authentication state as a stream (`Stream<User?>`).
- Firestore as a NoSQL document database.
- Real-time data synchronization.

---

### Section 6: Vidking WebView & JS Bridge
**Status**: ⏳ NOT STARTED
**Goal**: Integrate the external video player with full control.
**Deliverables**:
- [ ] `WebView` integration for `https://www.vidking.net/embed/movie/{id}`
- [ ] `JavascriptChannel` for two-way communication
- [ ] Capturing `PLAYER_EVENT` (play, pause, timeupdate)
- [ ] Saving playback progress to Firestore

**Teaching Focus**:
- `WebView` as a bridge between Flutter and the web world.
- Event-driven architecture and handling async streams.

---

## 📅 Progress Tracker

| Section | Status | Start Date | End Date | Notes |
|---------|--------|------------|----------|-------|
| 0. Setup | ✅ COMPLETED | June 26, 2026 | June 26, 2026 | Dependencies & Architecture scaffold done, challenge completed |
| 1. Declarative | ✅ COMPLETED | June 26, 2026 | June 26, 2026 | 3 counter approaches + MovieCard built |
| 2. Clean Arch | ✅ COMPLETED | June 26, 2026 | June 26, 2026 | Domain/Data layers, Repository, UseCases, DI with GetX |
| 3. UI Principles | ✅ COMPLETED | June 27, 2026 | June 27, 2026 | Hero banner, horizontal rows, bottom nav, 7-number system |
| 4. GetX State | ⏳ NOT STARTED | | | | |
| 5. Firebase Auth | ⏳ NOT STARTED | | | | |
| 6. WebView | ⏳ NOT STARTED | | | | |

---

## 🏅 Definition of Done (Per Section)

For each section to be considered complete:
1. ✅ Code compiles and runs on Android emulator/device.
2. ✅ Teaching notes are documented.
3. ✅ Inline challenges are completed by the user.
4. ✅ Progress is updated in this `SPRINT.md`.

---

## 🚀 Next Steps

1. ✅ Complete **Section 0: Project Bootstrapping** ✅
2. ✅ Complete **Section 1: Declarative vs Imperative** ✅
3. ✅ Complete **Section 2: Clean Code Architecture** ✅
4. ✅ Complete **Section 3: UI Principles** ✅
5. 🚀 Start **Section 4: GetX State Management (Rx + Obs + GetBuilder)**
6. Continue through each section until **Flixify is complete**

---

*Last Updated: June 27, 2026 — Sections 0, 1, 2, and 3 Complete. Ready for Section 4.*

