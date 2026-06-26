import 'package:flutter/material.dart';

import 'package:my_app/presentation/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// The main entry point of the application.
/// 
/// This is the first line of code that runs when the app starts.
/// 
/// [WidgetsFlutterBinding.ensureInitialized()] is a crucial line that 
/// initializes the Flutter framework. It must be called before any 
/// platform-specific code runs (like Firebase or loading assets).
///
/// We wrap the app in a try-catch block to handle any critical errors 
/// during startup, such as failing to load the .env.example file.
void main() async {
  // Necessary for async operations before runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env.example file.
  // This allows us to keep API keys out of the source code.
  try {
    await dotenv.load(fileName: '.env.example');
  } catch (e) {
    // In a real app, you might want to show a user-friendly error.
    // For now, we just log it.
    debugPrint('Could not load .env.example file: $e');
  }

  runApp(const MyApp());
}
