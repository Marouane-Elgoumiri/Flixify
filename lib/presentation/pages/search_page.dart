import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_theme.dart';

/// Placeholder page for the Search screen.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Search Screen Coming in Section 4',
          style: AppTheme.sectionTitle,
        ),
      ),
    );
  }
}
