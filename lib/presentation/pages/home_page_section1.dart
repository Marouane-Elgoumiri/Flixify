import 'package:flutter/material.dart';
import 'package:my_app/presentation/widgets/movie_card.dart';
import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/domain/entities/movie.dart';

/// Section 1: Declarative vs Imperative Programming
/// 
/// This page demonstrates the evolution of how we handle UI updates in Flutter:
/// 1. Imperative (The "Wrong" Way in Flutter)
/// 2. Declarative with setState (The Bridge)
/// 3. Reactive with ValueNotifier (The Modern Way)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flixify - Section 1'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.build_outlined), text: 'Imperative'),
              Tab(icon: Icon(Icons.auto_graph), text: 'Declarative'),
              Tab(icon: Icon(Icons.notification_important), text: 'Reactive'),
              Tab(icon: Icon(Icons.movie), text: 'Movie Card'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ImperativeCounter(),
            DeclarativeCounter(),
            ReactiveCounter(),
            MovieCardDemo(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 1. IMPERATIVE COUNTER (The "Wrong" Way in Flutter)
// ============================================================================
/// 
/// IMPERATIVE PROGRAMMING:
/// In imperative UI programming, you manually grab a reference to a UI
  /// element and tell it to change.
  ///
  /// Example from Android (Kotlin):
  /// val countText = findViewById(R.id.count_text)
  /// countText.text = "5"
  ///
  /// This approach treats the UI as mutable objects.
/// In Flutter, this breaks the framework's core assumption that widgets are immutable.
class ImperativeCounter extends StatefulWidget {
  const ImperativeCounter({super.key});

  @override
  State<ImperativeCounter> createState() => _ImperativeCounterState();
}

class _ImperativeCounterState extends State<ImperativeCounter> {
  int _counter = 0;

  // We will NOT use GlobalKey here because trying to modify a Text widget
  // directly is an anti-pattern. Instead, we will simulate the problem
  // by showing you WHY this approach fails in Flutter.
  //
  // The key insight: Text widget is immutable. You cannot change its 'data'.
  // You must build a NEW Text widget with the new value.

  void _increment() {
    // In imperative programming: _textWidget.text = "5"
    // In Flutter: This DOES NOT work. Widgets are immutable.
    // We demonstrate by trying to explain why setState is needed.
    
    // ignore: avoid_print
    print('Imperative approach: We want to change the text directly,');
    // ignore: avoid_print
    print('but Flutter widgets are IMMUTABLE. We must rebuild them.');
    
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Imperative Approach',
              style: AppTheme.sectionTitle,
            ),
            const SizedBox(height: 8),
            const Text(
              'In imperative programming (Android/iOS native),\n'
              'you grab a widget reference and mutate it directly.\n'
              'In Flutter, widgets are IMMUTABLE.\n'
              'You cannot change a Text widget after it is built.\n'
              'You must rebuild it with new data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange),
            ),
            const SizedBox(height: 32),
            Text(
              'Counter: $_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _increment,
              child: const Text('Increment (via setState bridge)'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. DECLARATIVE COUNTER (The Bridge)
// ============================================================================
/// 
/// DECLARATIVE PROGRAMMING (with setState):
/// 
/// In declarative programming, we don't touch widgets directly.
/// Instead, we say: "The UI is a pure function of State."
/// 
/// When state changes, we call setState(() { ... })
/// This tells Flutter: "Hey, rebuild this part of the tree."
/// Flutter then calls build() again with the new state.
/// 
/// THE WIDGET TREE IS A FUNCTION OF STATE:
/// UI = f(state)
class DeclarativeCounter extends StatefulWidget {
  const DeclarativeCounter({super.key});

  @override
  State<DeclarativeCounter> createState() => _DeclarativeCounterState();
}

class _DeclarativeCounterState extends State<DeclarativeCounter> {
  int _counter = 0;

  void _increment() {
    // setState is the BRIDGE between imperative thinking (call a function)
    // and declarative results (UI rebuilds with new state).
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Every time setState is called, this build() method is RE-EXECUTED.
    // We don't "update" the Text widget. We BUILD A NEW ONE.
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Declarative Approach',
            style: AppTheme.sectionTitle,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green),
            ),
            child: Column(
              children: [
                const Text(
                  'UI = f(state)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Counter: $_counter',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _increment,
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. REACTIVE COUNTER (The Modern Way)
// ============================================================================
/// 
/// REACTIVE PROGRAMMING with ValueNotifier:
/// 
/// ValueNotifier is a simple, built-in way to do reactive programming.
/// It holds a value and notifies listeners when the value changes.
/// 
/// Key difference from setState:
/// - setState: "Rebuild THIS widget and ALL its children"
/// - ValueNotifier: "Only rebuild the widgets LISTENING to this value"
/// 
/// State lives OUTSIDE the widget tree, making it easier to test and reuse.
/// This is the precursor to what GetX does with Rx/Obs.
class ReactiveCounter extends StatelessWidget {
  // ignore: unused_element
  ReactiveCounter({super.key});

  // State lives OUTSIDE the build method.
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  void _increment() {
    // We simply change the value.
    // The UI automatically updates because it's listening.
    _counter.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reactive Approach',
            style: AppTheme.sectionTitle,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              children: [
                const Text(
                  'State lives OUTSIDE the widget',
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
                const SizedBox(height: 8),
                // ValueListenableBuilder RE-BUILDS ONLY its child widget
                ValueListenableBuilder<int>(
                  valueListenable: _counter,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _increment,
            child: const Text('Increment'),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'ValueNotifier holds state OUTSIDE the widget.\n'
              'ValueListenableBuilder rebuilds ONLY its child.\n'
              'This is the precursor to GetX and Provider.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 4. THE MOVIE CARD DEMO
// ============================================================================
class MovieCardDemo extends StatelessWidget {
  const MovieCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the demo using a typed Movie entity (Clean Architecture).
    final movie = const Movie(
      id: 1078605,
      title: 'Deadpool & Wolverine',
      overview: 'A fading celebrity takes a dark turn...',
      posterPath: '/yF2Jt0y5yT1V202rrXxzzQ96QVw.jpg',
      backdropPath: null,
      releaseDate: '2024-07-26',
      voteAverage: 8.5,
      voteCount: 1500,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Declarative Movie Card',
            style: AppTheme.sectionTitle,
          ),
          const SizedBox(height: 16),
          // This widget is PURE. Given the same data, it always looks the same.
          MovieCard(movie: movie),
          const SizedBox(height: 16),
          const Text(
            'The MovieCard only knows about the data it receives.\n'
            'It has NO idea about state management, navigation, or API calls.\n'
            'This is the power of declarative widgets.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
