import 'package:flutter/material.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';

/// A live, side-by-side comparison of `Flexible` vs `Expanded`.
///
/// This widget exists for one teaching purpose: by the time you finish
/// Section 3, you should be able to look at this widget in your running
/// app and answer:
///   "What's the math behind how each colored block gets its size?"
///
/// The math (under a `Row`):
/// - `Expanded`   children first take `flex` weight, then DIVIDE all of the
///                 remaining space among themselves ONLY.
/// - `Flexible`   children ASK for their preferred size UP TO what's left,
///                 passing any leftover space to the next sibling.
///
/// In this widget:
///   ▸ `RedBlock` uses `Expanded(flex: 2, ...)` — greedy, takes 2/3 weight.
///   ▸ `BlueBlock` uses `Flexible(flex: 1, ...)` — asks for its natural
///        120px; if there's leftover, it stretches.
///
/// Toggle the `useFullWidth` switch to see the math in action.
class FlexibleVsExpandedDemo extends StatelessWidget {
  const FlexibleVsExpandedDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      color: AppTheme.primaryBlack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // === HEADLINE ROW: Expanded vs Flexible ===
          SizedBox(
            height: 120,
            child: Row(
              children: [
                // Expanded GREEDILY takes 2/3 of the space.
                const Expanded(
                  flex: 2,
                  child: _ColorBlock(
                    label: 'Expanded(flex: 2)',
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                // Flexible only takes up to its preferred 100px.
                // Whatever is left over goes to the next sibling.
                const Flexible(
                  flex: 1,
                  child: _ColorBlock(
                    label: 'Flexible(flex: 1)',
                    color: Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          // === TEXT EXPLANATION ===
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlack,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Row(width: 350, height: 120)',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.sm),
                Text(
                  '• Expanded(flex: 2) → grabs 2x of remaining = ~233px',
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
                Text(
                  '• SizedBox(8px)      → 8px',
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
                Text(
                  '• Flexible(flex: 1)  → grabs 1x of remaining = ~109px',
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorBlock extends StatelessWidget {
  const _ColorBlock({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppTheme.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
