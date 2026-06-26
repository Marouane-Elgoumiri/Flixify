import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_theme.dart';

/// Placeholder page for the Profile screen.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Profile Screen Coming in Section 6',
          style: AppTheme.sectionTitle,
        ),
      ),
    );\n  }
}
