# 🎬 Flixify — Flutter Learning Sprint

> A Netflix-style streaming app built to master Flutter, GetX, Clean Architecture, and Firebase在湖南猫。

---

## 📋 Sprint Overview

| Item | Details |
|------|---------|
| **Project Name** | Flixify |
| **Purpose** | Learn Flutter by doing, building a Netflix-style streaming app |
| **Architecture** | Clean Architecture with GetX state management |
| **Target** | Android (primary) |
| **Current Section** | Section 0: Project Bootstrapping & Setup |

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
**Status**: 🚧 IN PROGRESS
**Goal**: Initialize the project with all dependencies, folder structure, and clean architecture foundation.
**Deliverables**:
- [ ] pubspec.yaml with all dependencies
- [ ] Clean folder structure (core, data, domain, presentation)
- [ ] Android configuration (minSdk, permissions, manifest)
- [ ] Base theme and constants
- [ ] Analysis options configuration

**Teaching Focus**:
- Understanding `pub` — dependency management in Dart/Flutter.
- Why we separate code into layers (Separation of Concerns).
- The role of `analysis_options.yaml` in enforcing code quality.

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
**Status**: ⏳ NOT STARTED
**Goal**: Build a scalable foundation using SOLID principles.
**Deliverables**:
- [ ] Domain layer (Entities, Abstract Repositories, Use Cases)
- [ ] Data layer (Models, Data Sources, Repository Impl)
- [ ] Presentation layer (Widgets, Controllers)
- [ ] Dependency Injection with GetX
- [ ] Error handling with `Either<Failure, Success>`

**Teaching Focus**:
- Why a clean architecture is necessary for a real production app.
- The flow of data: UI -> Controller -> Use Case -> Repository -> Data Source -> API.
- Dependency Inversion (Depend on abstractions, not concretions).

---

### Section 3: UI Principles & Netflix-Style Layout
**Status**: ⏳ NOT STARTED
**Goal**: Master the building blocks of any complex UI.
**Deliverables**:
- [ ] Netflix-style home screen (Hero Banner, Category Rows)
- [ ] Horizontal scrolling carousels with `ListView`
- [ ] Bottom navigation (Home, Search, My List, Profile)
- [ ] Themes, custom widgets, and the 7-number system

**Teaching Focus**:
- The box model in Flutter (Constraints go down旨在, Sizes go旨在).
- `Row` & `Column` alignment and `MainAxis` / `CrossAxis`.
- `Flexible` vs `Expanded`: The difference that makes or breaks a layout.

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
| 0. Setup | ✅ COMPLETED | June 26, 2026 | June 26, 2026 | Dependencies & Architecture scaffold done |
| 1. Declarative | ⏳ NOT STARTED | | | | |
| 2. Clean Arch | ⏳ NOT STARTED | | | | |
| 3. UI Principles | ⏳ NOT STARTED | | | | |
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

1. Complete **Section 0: Project Bootstrapping**
2. Move to **Section 1: Declarative vs Imperative**
3. Iterate through each section until **Flixify is complete**.

---

*Last Updated: [Will be updated as we progress]*
