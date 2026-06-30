import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/presentation/controllers/auth_controller.dart';
import 'package:my_app/core/constants/app_route_names.dart';

/// Profile screen — shows the current user, a sign-out button, etc.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.secondaryBlack,
      ),
      body: Obx(() {
        final user = auth.user.value;
        return ListView(
          padding: const EdgeInsets.all(AppDimensions.md),
          children: [
            // Account card
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: AppTheme.darkGrey,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Signed in as',
                    style: TextStyle(color: AppTheme.lightGrey, fontSize: 12),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    user?.displayName?.isNotEmpty == true
                        ? user!.displayName!
                        : (user?.email ?? 'Anonymous'),
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user?.email != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      user!.email,
                      style: const TextStyle(color: AppTheme.lightGrey),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Watchlist shortcut
            ListTile(
              leading: const Icon(Icons.bookmark_added),
              title: const Text('My List'),
              onTap: () => Get.toNamed(AppRoutes.watchlist),
            ),

            const Divider(color: AppTheme.darkGrey),

            // Sign out
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.accentColor),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: AppTheme.accentColor),
              ),
              onTap: () async {
                await auth.signOutUser();
                // AuthGuard will redirect us to /login automatically
                // once auth.status flips to signedOut.
              },
            ),
          ],
        );
      }),
    );
  }
}
