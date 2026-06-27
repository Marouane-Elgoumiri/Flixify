import 'package:flutter/material.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';

/// A horizontal Netflix-style category row label.
///
/// Netflix puts a small, white, semi-bold subtitle above each horizontal
/// scroller (e.g. "Trending Now", "Continue Watching"). This widget
/// standardizes that micro-typography.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
