import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_theme.dart';

/// Placeholder page for the Watchlist screen.
class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Watchlist Screen Coming in Section 6',
          style: AppTheme.sectionTitle,
        ),
      ),
    );
  }
}
