import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:my_app/firebase_options.dart';
import 'package:my_app/presentation/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// The main entry point of the application.
///
/// Init order (matters!):
/// 1. Flutter bindings (required before any platform channel call).
/// 2. `.env` (TMDB API keys).
/// 3. `Firebase.initializeApp` — without this, every Firebase call
///    will throw a "no Firebase App has been initialized" error.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load env vars (TMDB).
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Could not load .env file: $e');
  }

  // Initialize Firebase with the generated options.
  // `DefaultFirebaseOptions.currentPlatform` points at the right
  // config for Android/iOS/web based on where we're running.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    debugPrint('Firebase.init failed: $e\n$st');
  }

  runApp(const MyApp());
}
