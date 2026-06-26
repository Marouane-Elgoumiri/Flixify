import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_theme.dart';

/// Placeholder page for the Home screen.
/// This will be built out in Section 3 and 4.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flixify'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to Flixify!\nHome Screen Coming in Section 3',
          textAlign: TextAlign.center,
          style: AppTheme.sectionTitle,
        ),
      ),
    );
  }
}
