import 'package:flutter/material.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';

/// A live, side-by-side comparison of `Flexible` vs `Expanded`,
/// plus a worked example of "how do I divide this row/column into
/// N equal parts?".
///
/// Mental model:
///   • `Expanded`   == `Flexible(fit: FlexFit.tight, ...)`
///         Forces the child to fill 100% of its allotted slot.
///         Greedy. Always stretches.
///
///   • `Flexible`   == `Flexible(fit: FlexFit.loose, ...)`
///         Lets the child be smaller than its slot (up to its
///         intrinsic / preferred size). Passes leftovers to
///         later siblings in the Flex.
///
/// Algorithm Flutter uses internally (Flex.performLayout):
///   1. Lay out non-flexible children at their natural size.
///   2. Sum the free space that's still available.
///   3. Divide that free space among `flex > 0` children in
///      proportion to their flex weight.
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
          // ============================================================
          // PART 1 — Row: Expanded (greedy) vs Flexible (natural-size)
          // ============================================================
          // Container(width: 360) locks the row's total width.
          // Inside that 360px:
          //   Expanded(flex: 2) → 2/3 * 360 = 240px (stretches)
          //   SizedBox(8)       →  8px
          //   Flexible(flex: 1) → 1/3 * 360 = 112px (stretches here
          //                          because the inner widget has no
          //                          preferred width; replace the
          //                          child with an Icon to see the
          //                          difference!)
          SizedBox(
            width: 350,
            height: 100,
            child: Row(
              children: const [
                Expanded(
                  flex: 5,
                  child: _ColorBlock(
                    label: 'Expanded(flex: 4)\n= 240px',
                    color: AppTheme.accentColor,
                  ),
                ),
                SizedBox(width: AppDimensions.sm),
                Flexible(
                  flex: 3,
                  child: _ColorBlock(
                    label: 'Flexible(flex: 3)\n= 112px',
                    color: Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          // ============================================================
          // PART 2 — Column: same rules, vertical axis
          // ============================================================
          // Total height = 200.
          //   Expanded(flex: 1) → 1/4 * 200 = 50px
          //   SizedBox(8)
          //   Expanded(flex: 3) → 3/4 * 200 = 150px
          SizedBox(
            height: 120,
            child: Column(
              children: const [
                Expanded(
                  flex: 1,
                  child: _ColorBlock(
                    label: '1/4 = 50px',
                    color: Color(0xFF4CAF50),
                  ),
                ),
                SizedBox(height: AppDimensions.sm),
                Expanded(
                  flex: 3,
                  child: _ColorBlock(
                    label: '3/4 = 150px',
                    color: Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          // ============================================================
          // PART 3 — The "N equal parts" recipe
          // ============================================================
          // Wrap any row/column in `MainAxisAlignment.spaceBetween`
          // (no flex needed!) for equal spacing, OR use N children
          // each wrapped in `Expanded(child: SizedBox())` to divide
          // the available space into N identical slots.
          Row(
            children: List.generate(
              5,
                  (i) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: _ColorBlock(
                    label: '1/5',
                    color: Color(0xFF9C27B0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 150, height: 50, color: Colors.purple,),
              Container(width: 150, height: 50, color: Colors.orange,),
              Container(width: 150, height: 50, color: Colors.teal,),
            ],
          ),
          const SizedBox(height: AppDimensions.md),

          // ============================================================
          // TEXT EXPLANATION
          // ============================================================
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
                  'Row(width: 360, height: 80)',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.sm),
                Text(
                  '• Expanded(flex: 2) → grabs 2/3 of remaining = 240px',
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
                Text(
                  '• SizedBox(8)      → 8px',
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
                Text(
                  '• Flexible(flex: 1) → grabs 1/3 of remaining = 112px',
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
                SizedBox(height: AppDimensions.sm),
                Text(
                  'Rule: all flex children share leftover space\n'
                      '       in proportion to their flex weight.',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontStyle: FontStyle.italic,
                  ),
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
          fontSize: 11,
        ),
      ),
    );
  }
}