import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/presentation/controllers/home_controller.dart';

/// A living, breathing **.obs / Obx** demonstration.
///
/// What this proves:
///   1. `var counter = 0.obs` — a reactive variable.
///   2. The `Obx(() => ...)` block **auto-rebuilds** when `counter`
///      changes. NO `update()` call necessary.
///   3. Notice: nothing OUTSIDE the `Obx` builder rebuilds when the
///      counter ticks. `GetBuilder`, on the other hand, would force
///      a wider rebuild.
///
/// Try tapping the button rapidly — observe that only the inner
/// widgets rebuild while the surrounding sliver stays still.
class ObxDemo extends StatelessWidget {
  const ObxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header — STATIC (rebuilds only when surrounding rebuild).
          const Text(
            'STEP 6 · Obx vs GetBuilder',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // ─── Here is the magic ───────────────────────────
          Obx(() {
            // Reads `counter.value` -> registers as a subscriber.
            // Whenever `counter.value` changes, ONLY this Obx rebuilds.
            return Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppTheme.darkGrey,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppTheme.accentColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.fingerprint,
                      size: 32, color: AppTheme.accentColor),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.counter.value} tap${controller.counter.value != 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: AppTheme.primaryText,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Only this Obx rebuilds. Nothing outside it.',
                          style: TextStyle(
                            color: AppTheme.lightGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.bumpCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: AppTheme.primaryText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.lg,
                          vertical: AppDimensions.sm),
                    ),
                    child: const Text('+1'),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: AppDimensions.md),

          // Tiny comparison block — purely informative.
          const Text(
            '• GetBuilder: WE call controller.update() ourselves.\n'
            '• Obx:      THE FRAMEWORK auto-detects variables we read.',
            style: TextStyle(
              color: AppTheme.lightGrey,
              fontSize: 11,
              fontFamily: 'monospace',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
